# belaPedal
A simple guitar effect pedal built using a belaBoard mini.

Uses two logarithmic 10K potentiometers, a switch and a LED. 

Choose between 4 different effects: Distortion, Tremolo, Reverb and Delay.

Potentiometer 0 controls mixing of dry and wet signal, measured in % of wet signal. E. g. 100% = only wet signal

Potentiometer 1 controls a parameter per effect:

- Distortion: Distortion amount by multiplying signal before normalizing, 1-11 times multiplication.
- Tremolo: Tremolo speed, 0-10 cycles per second.
- Reverb: Reverb time, from 0.5 - 4.5 seconds.
- Delay: multiplier on delay times, [0.1, 0.2, 0.3, 0.4] up to [1.1, 2.2, 3.3, 4.4]. Due to implementation of MultiTap.ar(), the value must be dialed in before the server is started.

Switch toggles effect bypass/active. When the effect is active, the LED is on.
