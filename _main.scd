/*============
belaPedal
by Valentin Möller

A simple supercollider program to run a belaBoard (mini) as a multi-FX guitar pedal.

Currently configured to use:
- 2 logarithmic 10K-potentiometers plugged in slot AnalogIn 0 and 1
- a on/off-switch with 3.3V power plugged in slot DigitalIn 14 (on belaBoard mini)
- an status-LED plugged in DigitialOut 15 leading to ground

Active effect must be selected before booting the SC server, by commenting out all but one of the lines 40-43.
============*/
s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 8;
s.options.numDigitalChannels = 16;

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.options.belaMaxScopeChannels = 8;

s.waitForBoot({
  (
  	b = Buffer.alloc(s, s.sampleRate*4.0, 2);
	SynthDef(\pedal, { arg out = 0;
			var in = SoundIn.ar([0,1]); //.belaScope(0); // sound input
			var button = DigitalIn.ar(14); // switch input
			var dry = in, wet, snd;

			// potentiometer input, scaled from logarithmic to linear.
			var fx_param0 = (10.pow(AnalogIn.ar(0).explin(0.001,1,0,1))/10);
			var fx_param1 = (10.pow(AnalogIn.ar(1).explin(0.001,1,0,1))/10);

			// Effect selection

			wet = (in * (fx_param1 * 10 + 1 )).tanh; // Distortion
			// wet = (in * SinOsc.ar(fx_param1 * 10, add: 0.4)); // Tremolo
			// wet = (in + GVerb.ar(in, 30, 0.5 + (fx_param1 * 4), 0.1, 0.95, 15, 0, 0.35, 0.3)); // Reverb
			// wet = (MultiTap.ar(`([1, 2, 3, 4] * (fx_param1 + 0.1)), [0.8, 0.6, 0.4, 0.2], in, bufnum: b.bufnum)); // Delay


			// Bypass and mixing
			snd = (in * (1-button)) + (((dry * (1-fx_param0))+(wet * fx_param0))*button);

			Out.ar(out, snd.dup);
			DigitalOut.ar(15, button);
		}).play;
	);

	s.sync;

});
ServerQuit.add({ 0.exit }); // quit if the button is pressed
