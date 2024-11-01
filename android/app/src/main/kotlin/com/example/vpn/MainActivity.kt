package com.example.vpn
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import android.content.Intent
import android.net.VpnService
import android.app.PendingIntent
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourapp/vpn"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "connectVPN" -> {
                    val args = call.arguments as? Map<*, *>
                    if (args != null) {
                        startVpnConnection(JSONObject(args))
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Invalid VPN configuration", null)
                    }
                }
                "disconnectVPN" -> {
                    stopVpnConnection()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startVpnConnection(config: JSONObject) {
        val intent = VpnService.prepare(this)
        if (intent != null) {
            Log.d("MainActivity", "Preparing VPN with config: $config")
            startActivityForResult(intent, 0)
        } else {
            Log.d("MainActivity", "Starting VPN service with config: $config")
            if (config.has("address") && config.has("port")) {
                onActivityResult(0, RESULT_OK, Intent().apply { putExtra("config", config.toString()) })
            } else {
                Log.e("MainActivity", "VPN configuration is missing address or port")
            }
        }
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 0 && resultCode == RESULT_OK) {
            val config = data?.getStringExtra("config")
            Log.d("MainActivity", "Received config in onActivityResult: $config")
            val intent = Intent(this, MyVpnService::class.java).apply {
                putExtra("config", config)
            }
            startService(intent)
        }
    }

    private fun stopVpnConnection() {
        stopService(Intent(this, MyVpnService::class.java))
    }
}
