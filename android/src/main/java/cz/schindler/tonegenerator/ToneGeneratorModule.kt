package cz.schindler.tonegenerator

import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class ToneGenerator {
  private val sampleDurationMs = 50
  private val sampleRate = 11025
  private val sampleCount = sampleDurationMs * sampleRate

  private val audioTrackBufferLength = AudioTrack.getMinBufferSize(
    sampleRate,
    AudioFormat.CHANNEL_OUT_MONO,
    AudioFormat.ENCODING_PCM_16BIT
  )
  private var audioTrack: AudioTrack = AudioTrack(
    AudioManager.STREAM_MUSIC,
    sampleRate,
    AudioFormat.CHANNEL_OUT_MONO,
    AudioFormat.ENCODING_PCM_16BIT,
    audioTrackBufferLength,
    AudioTrack.MODE_STREAM
  )

  private var isPlaying = false

  public fun play(frequency: Double) {
    this.isPlaying = true

    val buffer = ShortArray(this.sampleCount)
    for (i in 0 until this.sampleCount) {
      buffer[i] = (java.lang.Math.sin(2 * java.lang.Math.PI * i / (this.sampleRate / frequency)) * Short.MAX_VALUE).toInt().toShort()
    }

    this.audioTrack.write(buffer, 0, this.sampleCount)
    this.audioTrack.play();
  }

  public fun stop() {
    if (!this.isPlaying) {
      return
    }

    this.isPlaying = false

    this.audioTrack.pause()
    this.audioTrack.flush()
    this.audioTrack.stop()
  }

  public fun getIsPlaying(): Boolean {
    return this.isPlaying
  }

  public fun setFrequency(frequency: Double) {
    if (!this.isPlaying) {
      return
    }

    this.audioTrack.pause()
    this.audioTrack.flush()

    this.play(frequency)
  }
}

class ToneGeneratorModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("ToneGenerator")

    val toneGenerator = ToneGenerator()

    Function("getIsPlaying") {
      return@Function toneGenerator.getIsPlaying()
    }

    AsyncFunction("play") { value: Double ->
      toneGenerator.play(value)
    }

    AsyncFunction("stop") {
      toneGenerator.stop()
    }

    AsyncFunction("setFrequency") { value: Double ->
      toneGenerator.setFrequency(value)
    }
  }
}
