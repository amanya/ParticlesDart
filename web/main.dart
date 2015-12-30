// This file is part of ParticlesDart.

// ParticlesDart is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// ParticlesDart is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with ParticlesDart.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:html';
import 'dart:math';
import 'package:game_loop/game_loop_html.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;

const int PARTICLE_SIZE = 10;

void main() {
  canvas = querySelector('#canvas');
  ctx = canvas.getContext('2d');

  var particle = new Particle(new Point(10, 10), 'salmon');

  GameLoopHtml gameLoop = new GameLoopHtml(canvas);
  gameLoop.onUpdate = ((gameLoop) {
    particle.updatePosition(new Point(1, 1));
  });
  gameLoop.onRender = ((gameLoop) {
    particle.draw();
  });
  gameLoop.start();
}

class Particle {
  Point position;
  String color;

  Particle(this.position, this.color);

  void updatePosition(Point delta) {
    this.position += delta;
  }

  void updateColor(String color) {
    this.color = color;
  }

  void draw() {
    ctx
      ..fillStyle = this.color
      ..strokeStyle = 'white';

    final int x = this.position.x * PARTICLE_SIZE;
    final int y = this.position.y * PARTICLE_SIZE;

    ctx
      ..fillRect(x, y, PARTICLE_SIZE, PARTICLE_SIZE)
      ..strokeRect(x, y, PARTICLE_SIZE, PARTICLE_SIZE);
  }
}
