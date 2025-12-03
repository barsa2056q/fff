package com.barsa2056q.arcyber

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.webkit.PermissionRequest
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import android.webkit.WebView
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat

class MainActivity : AppCompatActivity() {
    private lateinit var webView: WebView
    private var pendingPermissionRequest: PermissionRequest? = null

    private val requestCameraPermission = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { granted ->
        if (granted) {
            pendingPermissionRequest?.let {
                it.grant(it.resources)
                pendingPermissionRequest = null
            }
        } else {
            Toast.makeText(this, "Camera permission is required for AR features", Toast.LENGTH_LONG).show()
            pendingPermissionRequest = null
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        webView = WebView(this)
        setContentView(webView)

        val ws: WebSettings = webView.settings
        ws.javaScriptEnabled = true
        ws.mediaPlaybackRequiresUserGesture = false
        ws.allowFileAccess = true
        ws.allowContentAccess = true
        ws.domStorageEnabled = true

        webView.webChromeClient = object : WebChromeClient() {
            override fun onPermissionRequest(request: PermissionRequest?) {
                runOnUiThread {
                    if (request == null) return@runOnUiThread
                    val resources = request.resources
                    // Если уже есть разрешение CAMERA — даём его WebView
                    if (ContextCompat.checkSelfPermission(this@MainActivity, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
                        request.grant(resources)
                    } else {
                        // Сохраняем запрос и запрашиваем системное разрешение
                        pendingPermissionRequest = request
                        requestCameraPermission.launch(Manifest.permission.CAMERA)
                    }
                }
            }
        }

        // Загрузка локальной страницы внутри assets/www/index.html
        webView.loadUrl("file:///android_asset/www/index.html")
    }

    override fun onDestroy() {
        webView.apply {
            clearHistory()
            removeAllViews()
            destroy()
        }
        super.onDestroy()
    }
}