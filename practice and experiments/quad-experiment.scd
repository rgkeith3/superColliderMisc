// set up SC for 4channel

// see current settings
s.options.numAudioBusChannels;
s.options.numInputBusChannels;
s.options.numOutputBusChannels;
(
// set in outs to 4 each
s.options.numOutputBusChannels = 4;
s.options.numInputBusChannels = 4;
)
// see available devices
ServerOptions.devices;

// "UMC404HD 192k"

(
s.options.inDevice = "UMC404HD 192k";
s.options.outDevice = "UMC404HD 192k";
)

s.boot;

s.meter;

(
{
	Out.ar(3, WhiteNoise.ar())
}.play
)

({
	PanAz.ar(4, WhiteNoise.ar(), MouseX.kr(0, 2), width: MouseY.kr(0, 4))
}.play)
// ok, if you've plugged red into red and white into white on the audio interface you may notice that as you pan your mouse across the screen, tho the number of the channel outputing goes from 0 - 3 in order, the way you may experience it is front-left, front-right, back-left, back-right, and I thnk for quad stuff to work the order of output busses should be front-left, front-right, back-right, back-left.
// until i find out how to change the server settings, i'm just gonna switch the left and right channels on the back speakers on the interface.


