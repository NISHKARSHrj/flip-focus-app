package com.example.flip.helpers

import android.content.Context
import android.util.Log
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.exoplayer.ExoPlayer
import com.example.flip.R

object SoundHelper {

    private var player: ExoPlayer? = null

    private fun createPlayer(context: Context) {

        if (player != null) return

        player = ExoPlayer.Builder(context).build()

        player?.addListener(object : Player.Listener {

            override fun onPlaybackStateChanged(state: Int) {
                Log.d("FlipSound", "State = $state")
            }

            override fun onPlayerError(error: PlaybackException) {
                Log.e("FlipSound", "Error = ${error.message}")
            }
        })
    }

    fun playRain(context: Context) {

        createPlayer(context)

        val uri =
            "android.resource://${context.packageName}/${R.raw.rain}"

        val mediaItem = MediaItem.fromUri(uri)

        player?.setMediaItem(mediaItem)

        player?.prepare()

        player?.repeatMode = Player.REPEAT_MODE_ONE

        player?.playWhenReady = true

        player?.play()

        Log.d("FlipSound", "Rain Started")
    }

    fun stopRain() {

        player?.stop()

        player?.release()

        player = null

        Log.d("FlipSound", "Rain Stopped")
    }
}