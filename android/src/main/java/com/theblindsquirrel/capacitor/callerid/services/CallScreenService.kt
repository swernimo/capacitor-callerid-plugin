package com.unanet.cosentialformobile.services

import android.telecom.Call
import android.telecom.CallScreeningService
import android.util.Log

class CallScreenService: CallScreeningService() {
    private val TAG: String = CallScreenService::class.toString()

    override fun onScreenCall(callDetails: Call.Details) {
        Log.d(TAG, "onScreenCall: ")
        var number = getPhoneNumber(callDetails)
        var response = CallResponse.Builder().build()
        respondToCall(callDetails, response)
    }

    private fun getPhoneNumber(callDetails: Call.Details): String {
        return callDetails.handle.toString()//.removeTelPrefix().parseCountryCode()
    }
}