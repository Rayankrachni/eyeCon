package com.example.eyedetector

import android.annotation.TargetApi
import android.content.Context
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraDevice
import android.hardware.camera2.CaptureRequest
import android.hardware.camera2.CameraManager
import android.os.Build
import android.util.Range
import android.util.Log
import android.media.MediaRecorder
import android.os.Environment
import java.io.File
import android.hardware.camera2.CameraCaptureSession
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourapp/camera_fps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when(call.method) {
                "setCameraFps" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP && hasCamera()) {
                        val desiredFps = call.argument<Int>("fps") ?: 15
                        openCamera(desiredFps) // Open the camera and set FPS
                        result.success(true)
                    } else {
                        result.error("Unsupported", "Camera2 API is not supported or no camera found on this device.", null)
                    }
                }
                "startRecording" -> {
                    startRecording()
                    result.success(true)
                }
                "stopRecording" -> {
                    stopRecording()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }


        }
    }

    private var cameraDevice: CameraDevice? = null

    private val cameraDeviceCallback = @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    object : CameraDevice.StateCallback() {
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

    private fun hasCamera(): Boolean {
        val manager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            manager.cameraIdList.isNotEmpty()
        } else {
            TODO("VERSION.SDK_INT < LOLLIPOP")
        }
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    private fun openCamera(fps: Int) {
        val manager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
        try {
            val cameraId = manager.cameraIdList[0]
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                manager.openCamera(cameraId, cameraDeviceCallback, null)
            }
            setCameraFps(fps)
            initMediaRecorder(15) // Set FPS after opening the camera
        } catch (e: CameraAccessException) {
            // Handle CameraAccessException.
        } catch (e: Exception) {
            // Handle other exceptions.
        }
    }
    private var mediaRecorder: MediaRecorder? = null

    private fun initMediaRecorder(fps: Int) {
        mediaRecorder = MediaRecorder().apply {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
                setVideoSource(MediaRecorder.VideoSource.SURFACE)
            }
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
                setVideoEncoder(MediaRecorder.VideoEncoder.H264)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
                setVideoFrameRate(fps)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
                setVideoSize(1920, 1080)
            }  // Example resolution, you might want to adjust this based on your camera's capability

            // Setting path to save video. Adjust if necessary.
            val videoFile = File(Environment.getExternalStorageDirectory(), "recorded_video.mp4")
            setOutputFile(videoFile.absolutePath)
        }
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    private fun startRecording() {
        cameraDevice?.createCaptureSession(listOf(mediaRecorder?.surface), object : CameraCaptureSession.StateCallback() {
            override fun onConfigured(session: CameraCaptureSession) {
                val captureBuilder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_RECORD)
                } else {
                    TODO("VERSION.SDK_INT < LOLLIPOP")
                }
                captureBuilder?.addTarget(mediaRecorder?.surface!!)
                session.setRepeatingRequest(captureBuilder!!.build(), null, null)

                // Start the actual recording
                mediaRecorder?.start()
            }

            override fun onConfigureFailed(session: CameraCaptureSession) {
                Log.e("CameraRecorder", "Configuration failed")
            }
        }, null)
    }

    private fun stopRecording() {
        mediaRecorder?.stop()
        mediaRecorder?.reset()
        mediaRecorder?.release()
        mediaRecorder = null
    }

    private fun setCameraFps(fps: Int) {
        Log.d("CameraFPS", "Setting camera FPS to $fps")
        cameraDevice?.let { device ->
            val captureBuilder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                device.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW)
            } else {
                TODO("VERSION.SDK_INT < LOLLIPOP")
            }
            captureBuilder.set(CaptureRequest.CONTROL_AE_TARGET_FPS_RANGE, Range(fps, fps))
            // Restart your camera preview session with this modified captureBuilder.

            cameraDevice?.close()  // Close camera after setting FPS
            cameraDevice = null
        } ?: run {
            Log.e("CameraFPS", "CameraDevice is null, cannot set FPS.")
        }
        Log.d("CameraFPS", "Camera FPS set successfully")
    }
}
