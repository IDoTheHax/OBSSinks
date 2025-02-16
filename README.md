# Audio Setup Script README

## Overview

This script automates the setup of audio sinks and routing using PulseAudio (or PipeWire via the PulseAudio compatibility layer). It's designed to create null sinks for capturing audio in applications like OBS Studio and combine them with your primary audio output device.

## Prerequisites

*   A Linux-based operating system with PulseAudio or PipeWire (with PulseAudio compatibility).
*   `pactl` command-line tool (part of the PulseAudio utilities).  If using PipeWire, `pw-cli` might also be required for some configurations.
*   `sudo` privileges.
*   Basic understanding of audio routing and configuration.
*   A Focusrite Scarlett 4i4 USB audio interface (or adjust the device name accordingly).

## Installation

1.  **Download the script:**
    Download the `obs_sinks_creator.sh` script to your home directory or preferred location.

2.  **Make the script executable:**

    ```
    chmod +x obs_sinks_creator.sh
    ```

3.  **(Recommended) Place the script in a safe location:**

    Consider moving the script to `~/bin` or `~/.local/bin`.  Ensure that this directory is in your `$PATH`.

## Usage

### Manual Execution

To run the script manually, execute the following command:

```
sudo ./obs_sinks_creator.sh
```


You'll be prompted for your `sudo` password.  The script will then create the necessary audio sinks and set the default audio output.

### Running on Login (Recommended Method)

To have the script run automatically each time you log in, follow these steps:

1.  **Edit your `~/.profile` (or `~/.bash_profile`) file:**

    ```
    nano ~/.profile
    ```

2.  **Add the following line to the end of the file:**

    ```
    sudo /path/to/obs_sinks_creator.sh  # Replace with the actual path
    ```
    *IMPORTANT NOTE: As of 2/16/2025, It might not be wise to run this script using sudo. Edit the script so that the functions get the username. This should solve the need of the "sudo" command. This script is not designed to run on boot but when a user logs in*
    *If you don't already have a .profile file, you can try using ~/.bashrc*

3.  **Save the file and exit.**

4.  **Log out and log back in.**

    The script will now run automatically when you log in.

### Script Configuration

The following parameters can be configured within the script:

*   **Audio Device Names:**  The script is configured to use "alsa\_output.usb-Focusrite\_Scarlett\_4i4\_USB\_D80FBQQ0C17D6F-00.analog-surround-40" as the primary audio device.  Modify this to match the name of your audio interface as reported by `pactl list short sinks`.
*   **Sink Names:**  The names of the null sinks (e.g., "MusicSink", "GameSink", "DiscordSink") and combined outputs can be adjusted by editing the corresponding `pactl` commands within the script.
*   **Descriptions:** The descriptions of each sink for the OBS application

## Troubleshooting

*   **"Connection refused" or "Failed to connect to PulseAudio" errors:**  This typically indicates that PulseAudio is not running when the script is executed.  Ensure that PulseAudio is properly started and configured for your user session.  If using PipeWire, ensure PipeWire's PulseAudio compatibility layer is running (`pipewire-pulse`).

*   **"Module initialization failed" error:** This might mean that the module combine sink is not properly installed. Reinstall PulseAudio or the related package containing that specific module.

*   **Sinks are not created:** Check for typos in the device names and ensure the device is properly connected.

*   **Audio is not routed correctly:** Double-check the slave device names in the combined sink commands.  Ensure that the null sinks are created successfully before creating the combined outputs.
    *Ensure the device you are choosing matches the name of the device you're using*

## Advanced Configuration (Optional)

*   **Using WirePlumber:**  For more advanced audio routing and management, consider using a session manager like WirePlumber.  WirePlumber provides a flexible way to configure PipeWire's audio graph.

## Important Notes

*   This script requires `sudo` privileges because it modifies system-wide PulseAudio settings.
*   Exercise caution when modifying the script, especially when dealing with audio device names.  Incorrect device names can lead to audio routing issues.
*   Consider using a more sophisticated audio routing solution if you require complex audio configurations or dynamic routing.
*   Check the logs with `journalctl -xe | grep pulseaudio` for any related warnings

## Support

If you encounter any issues or have questions about this script, please create an issue on the GitHub repository.

# Made With Love by IDoTheHax

Published under the MIT License

Join the discord: [discord.gg/aj2jfhSyZE](https://discord.gg/invite/aj2jfhSyZE)
