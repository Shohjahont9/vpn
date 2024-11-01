package com.example.vpn

import android.app.PendingIntent
import java.net.InetSocketAddress
import java.nio.channels.DatagramChannel
import org.json.JSONObject
import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor
import kotlin.concurrent.thread
import android.util.Log

class MyVpnService : VpnService() {

    private var parcelFileDescriptor: ParcelFileDescriptor? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val configString = intent?.getStringExtra("config")
        if (configString != null) {
            val config = JSONObject(configString)
            thread {
                configureVPN(config)
            }
        }
        return START_STICKY
    }

    private fun configureVPN(config: JSONObject) {
        val builder = Builder()

        try {
            val serverAddress = config.getString("address")
            val serverPort = config.getInt("port")

            builder.addAddress("10.0.0.2", 24)
            builder.addRoute("0.0.0.0"/*serverAddress*/, 0)

            builder.setSession(config.getString("name"))
            builder.setMtu(1400)
            builder.addDnsServer("8.8.8.8")

            val intent = PendingIntent.getActivity(
                this, 0, Intent(this, MainActivity::class.java), PendingIntent.FLAG_IMMUTABLE
            )
            builder.setConfigureIntent(intent)

            // Establish the VPN connection
            parcelFileDescriptor = builder.establish() ?: throw Exception("Failed to establish VPN")
            Log.d("MyVpnService", "VPN established successfully to $serverAd*dress:$serverPort")

        } catch (e: Exception) {
            Log.e("MyVpnService", "Error establishing VPN: ${e.message}", e)
        }
    }

    private fun closeVpn() {
        try {
            parcelFileDescriptor?.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        closeVpn() // Ensure to close the VPN connection on service destruction
    }
}