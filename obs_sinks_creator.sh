#!/bin/bash

# Get the user who is logged in
SCRIPT_USER=$(who | awk '{print $1}' | sort | uniq | head -1)

# Function to run pactl commands as the logged-in user
run_pactl() {
    sudo -u $SCRIPT_USER PULSE_RUNTIME_PATH="/run/user/$(id -u $SCRIPT_USER)/pulse" pactl "$@"
}

# Function to check if a sink exists
sink_exists() {
    run_pactl list short sinks | grep -q "$1"
}

# Wait for audio server to start
echo "Waiting for audio server..."
sleep 10

# Create null sinks
for sink in MusicSink GameSink DiscordSink; do
    if ! sink_exists "$sink"; then
        echo "Creating $sink..."
        run_pactl load-module module-null-sink sink_name=$sink sink_properties=device.description=OBS_${sink%Sink}_Capture
        if ! sink_exists "$sink"; then
            echo "Failed to create $sink"
        fi
    else
        echo "$sink already exists"
    fi
done

# Create combined sinks
for combined in CombinedOutput CombinedOutputGame CombinedOutputDiscord CombinedOutputAll; do
    if ! sink_exists "$combined"; then
        echo "Creating $combined..."
        case $combined in
            CombinedOutput)
                slaves="MusicSink,alsa_output.usb-Focusrite_Scarlett_4i4_USB_D80FBQQ0C17D6F-00.analog-surround-40"
                ;;
            CombinedOutputGame)
                slaves="GameSink,alsa_output.usb-Focusrite_Scarlett_4i4_USB_D80FBQQ0C17D6F-00.analog-surround-40"
                ;;
            CombinedOutputDiscord)
                slaves="DiscordSink,alsa_output.usb-Focusrite_Scarlett_4i4_USB_D80FBQQ0C17D6F-00.analog-surround-40"
                ;;
            CombinedOutputAll)
                slaves="DiscordSink,GameSink,MusicSink,alsa_output.usb-Focusrite_Scarlett_4i4_USB_D80FBQQ0C17D6F-00.analog-surround-40"
                ;;
        esac
        run_pactl load-module module-combine-sink sink_name=$combined slaves=$slaves
        if ! sink_exists "$combined"; then
            echo "Failed to create $combined"
        fi
    else
        echo "$combined already exists"
    fi
done

# Set default sink
echo "Setting default sink to CombinedOutputAll..."
run_pactl set-default-sink CombinedOutputAll

echo "Audio setup completed. Current sinks:"
run_pactl list short sinks
