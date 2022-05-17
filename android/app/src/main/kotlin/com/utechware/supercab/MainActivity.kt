package com.utechware.thesupercab

import android.annotation.SuppressLint
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Base64
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.math.BigInteger
import java.security.MessageDigest
import io.flutter.embedding.android.FlutterFragmentActivity


class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "super_cab_location_picker"

    @SuppressLint("PackageManagerGetSignatures")
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getPlatformVersion") {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            if (call.method == "getSigningCertSha1") {
                try {
                    val info: PackageInfo = applicationContext.packageManager.getPackageInfo(call.arguments<String>(), PackageManager.GET_SIGNATURES)
                    for (signature in info.signatures) {
                        val md: MessageDigest = MessageDigest.getInstance("SHA1")
                        md.update(signature.toByteArray())

                        val bytes: ByteArray = md.digest()
                        val bigInteger = BigInteger(1, bytes)
                        val hex: String = String.format("%0" + (bytes.size shl 1) + "x", bigInteger)
                        val hashKey = String(Base64.encode(md.digest(), 0))

                        result.success(hex)
                    }
                } catch (e: Exception) {
                    result.error("ERROR", e.toString(), null)
                }
            } else {
                result.notImplemented()
            }

        }
    }
}
