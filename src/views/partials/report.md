# Report
*This document details the steps we went through in order to reach the point where we were able to implement our working UI for ___CA357 HCI___ module assignment*.

___Chosen application___: *Game of Connect 4.*

___Reference___: *Assignment details can be found [ here](http://www.computing.dcu.ie/~dfitzpat/ca357/assignment).*


## Choice of Technologies
*This part exposes the technologies we used to develope our application.
The application uses exclusively front-end technologies.*

### Languages:
We used languages that are extensions to the web standards (ie.: JavaScript 5.1, HTML5 and CSS3). That enabled us to write code faster. You can find source code [here](https://github.com/kirly-af/connect4/tree/master/src).
* [**CoffeeScript**](http://coffeescript.org/): a programming language that transpiles to JavaScript
* [**Jade**](http://jade-lang.com/): a terse language for writing HTML templates
* [**Sass**]((http://jade-lang.com/): a scripting language that is interpreted into CSS

### Libraries:
For this project, we used several popular JavaScript libraries.
* [**Phaser**](http://www.phaser.io/): a HTML5 game framework
* [**jQuery**](http://jquery.com/): the most famous JavaScript library that abstracts the DOM API
* [**Bootstrap**](http://getbootstrap.com/): a HTML5 framework for developing responsive web projects

### Toolchain:
No page preprocessing server (example: PHP) is necessary. However we did use preprocessing on client-side using some famous node.js related softwares.

* [**npm**](https://www.npmjs.com/): the node.js package manager
* [**Bower**](http://bower.io/): a dependency manager used to manage installation of third party libraries
* [**Gulp**](http://gulpjs.com/): a modern task runner, used for example to tanspile CoffeeScript to JavaScript

### Optimization:
That toolchain enabled us to reuse common code, and so to have more concise code.
But the real strength of it is that we have been able to reduce page loading overhead. In effect Gulp tasks allow to:
* optimize assets such as scripts and stylesheets by concatenation and minification
* limit the necessary HTTP GET requests to fetch resources

## Prototype description
*We will discuss here the different aspects of the working UI.*

### Gameplay:
We decided that the game will be played with mouse. It would have been possible to play with keyboard instead, although it would not be very convenient on devices with touch screens (smartphones, tablets...).

The gameplay is really simple. The players have to touch the column in which they want to put the disc.

When the game ends, the players can not do any more actions, apart from starting a new game or return to the project homepage.

### User experience:
* When a column is hovered by the mouse, it is darkened so the player does not wonder if it is making a mistake.
* Discs colors are the same as those of the original game so that it looks familiar to the players.
* An option for restarting the game is available by pressing the pause button
* We integrated a _help_ button (**?** icon) that shows a short reminder of the rules
* We thought about the possibility to make a mistake on devices with touchscreens. That is the reason why we decided to add an _undo_ button. Of course it should not be used for cheating purposes.

### Assets design:
We designed the game assets by ourselves. Full list can be found [here](https://github.com/kirly-af/connect4/tree/master/src/assets/images). It includes the grid, the buttons and the discs. The choice of the colors is arbitrary, but we tried to provide an experience similar to the original game, that is why we kept the original game disc colors (ie.: red and yellow).

### Responsivity:
Responsivity is an essential feature of a modern application that should run on various screen sizes. We made sure the application could be used on any device. See below the necessary steps to provide our full responsive game:

* Calculate the best ratio so that the game fits the screen
* Rescale the sprites to that ratio
* Calculate the position so that the game is centered

Everytime the window is resized, we have to repeat those steps, since the ratio changes and we have to find the new position.

*Phaser* provides a set of [methods](http://phaser.io/docs/2.3.0/Phaser.Group.html#scale) for its graphic objects that enabled us to reach that objective. Thanks to that framework, responsivity was not difficult to manage.

### Menus:
The game menus are actually implemented with [Bootstrap modals](http://getbootstrap.com/javascript/#modals-examples). Functionnally, they are similar to JavaScript [popup boxes](https://developer.mozilla.org/en-US/docs/Web/API/Window/alert), though they have multiple advantages:
* not real popups, therefore can not be blocked by the web browser
* natively responsive
* easy to integrate in the code
* convenient API that works well with jQuery
* fully customizable with stylesheets
* not resource consumming
