package com.webreinvent.vaahflutter

import android.os.Bundle
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "snackbar_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "showSnackbar") {
                showSnackbar()
                result.success("Snackbar displayed")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun showSnackbar() {
        runOnUiThread {
            Toast.makeText(this, "This is a test", Toast.LENGTH_SHORT).show()
        }
    }
}
