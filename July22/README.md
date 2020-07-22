Picture of Schematics

![](109346179_288246629277613_8382526651681805647_n.jpg)

Picture of Board

![](115688016_3389613327743364_8155234989394902438_n.jpg)

My circuit contains a photoresister, switch, and two LEDs. The photoresister is pretty simple. When it detects a lot of light the LED's light is low, but if it detects less light the LED's light will be stronger. This was mainly achieved using the map function to reverse the trend and change the values from the range of 0-1200 to the range of 255-0. The digital input, the switch was harder. Whenever you click it, the LED blinks three times each for half a second. This is where I had some trouble because I was trying to use the Blink without delay idea. However I figured it out and it works now.
