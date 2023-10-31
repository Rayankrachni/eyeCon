package com.example.eyedetector

import android.content.Context
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraDevice
import android.hardware.camera2.CaptureRequest
import android.hardware.camera2.CameraManager
import android.os.Build
import android.util.Range
import android.util.Log
import android.os.Handler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourapp/camera_fps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->

            if (call.method == "setCameraFps") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    val desiredFps = call.argument<Int>("fps") ?: 15
                    openCamera() // Open the camera

                    // Adding a delay
                    Handler().postDelayed({
                        setCameraFps(desiredFps)
                    }, 2000)  // Delay for 2 seconds

                    result.success(true)
                } else {
                    result.error("Unsupported", "Camera2 API is not supported on this device.", null)
                }
            }
            else {
                result.notImplemented()
            }
        }
    }

    private var cameraDevice: CameraDevice? = null

    private val cameraDeviceCallback = object : CameraDevice.StateCallback() {
        override fun onOpened(camera: CameraDevice) {
            cameraDevice = camera
        }

        override fun onDisconnected(camera: CameraDevice) {
            cameraDevice?.close()
            cameraDevice = null
        }

        override fun onError(camera: CameraDevice, error: Int) {
            cameraDevice?.close()
            cameraDevice = null
            // Handle any additional error scenarios.
        }
    }

    private fun openCamera() {
        val manager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
        try {
            val cameraId = manager.cameraIdList[0]
            manager.openCamera(cameraId, cameraDeviceCallback, null)
        } catch (e: CameraAccessException) {
            // Handle CameraAccessException.
        } catch (e: Exception) {
            // Handle other exceptions.
        }
    }


    private fun setCameraFps(fps: Int) {
        Log.d("CameraFPS", "Setting camera FPS to $fps")
        cameraDevice?.let { device ->
            val captureBuilder = device.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW)
            captureBuilder.set(CaptureRequest.CONTROL_AE_TARGET_FPS_RANGE, Range(fps, fps))
            // Restart your camera preview session with this modified captureBuilder.
        }
        Log.d("CameraFPS", "Camera FPS set successfully")

    }
}
