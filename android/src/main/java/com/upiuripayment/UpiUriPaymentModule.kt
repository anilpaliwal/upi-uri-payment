package com.upiuripayment

import android.content.Intent
import android.net.Uri
import android.util.Log

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod


class UpiUriPaymentModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
    fun openUPIApp(url: String, promise: Promise) {
        if (url.contains("upi://pay")) {
           try {
            Log.d("UPIModule", "Received URL: $url")
            val uri = Uri.parse(url)
            val intent = Intent(Intent.ACTION_VIEW, uri)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

            reactContext.startActivity(intent)
            promise.resolve("SUCCESS")
          
        } catch (e: Exception) {
            Log.e("UPIModule", "Error: ${e.message}")
            promise.reject("ERROR", e.message)
        }
        } else {
            promise.reject("ERROR", "Invalid UPI URL")
        }
    }

  companion object {
    const val NAME = "UpiUriPayment"
  }
}



