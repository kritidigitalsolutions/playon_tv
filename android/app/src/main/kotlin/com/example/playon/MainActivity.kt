package com.example.playon

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            window.decorView.requestFocus()
        }
    }
}