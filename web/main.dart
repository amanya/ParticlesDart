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

const double PARTICLE_SIZE = 10;
const List<String> COLORS = const ['red', 'orange'];

Random RNG = new Random();

void main() {
  canvas = querySelector('#canvas');
  ctx = canvas.getContext('2d');

  GameLoopHtmlState initial_state = new InitialState(20);
  GameLoopHtml gameLoop = new GameLoopHtml(canvas);
  gameLoop.state = initial_state;
  gameLoop.start();
}

void drawText(CanvasRenderingContext2D ctx, String text, Point position) {
  ctx
    ..font = '14px sans-serif'
    ..lineWidth = 3
    ..strokeStyle = "black"
    ..strokeText(text, position.x, position.y)
    ..fillStyle = "white"
    ..fillText(text, position.x, position.y);
}

class InitialState extends SimpleHtmlState {
  final int numParticles;
  List<Particle> particles;
  int angle = 0;
  Point center;
  int width;
  int height;

  InitialState(this.numParticles) {
    width = window.innerWidth;
    height = window.innerHeight;
    canvas.width = width;
    canvas.height = height;

    int x = width / 2 - PARTICLE_SIZE / 2;
    int y = height / 2 - PARTICLE_SIZE / 2;
    center = new Point(x, y);
    int interval = 2 * PI / numParticles;
    particles = new List.generate(
        numParticles,
        (n) => new Particle(
            new Point(x + cos(interval * n) * 100, y + sin(interval * n) * 100),
            new Point(0, 0),
            COLORS[0]));
  }

  void onRender(GameLoop gameLoop) {
    ctx
      ..fillStyle = "rgb(0,0,0)"
      ..fillRect(0, 0, width, height);
    particles.forEach((particle) => particle.draw());
    double fps = 1 / gameLoop.dt;
    drawText(ctx, 'FPS: ${fps.round()}', new Point(20, 20));
  }

  void onUpdate(GameLoop gameLoop) {
    if (particles.length < numParticles) {
      particles.add(new Particle.randomInitialize());
    }
    angle += .1;
    if (angle >= 2 * PI) {
      angle = 0;
    }
    center += new Point(0, sin(angle) * 5);
    particles.forEach((particle) {
      int xp = 0;
      int yp = sin(angle) * 5;
      int x = particle.position.x - width / 2;
      int y = particle.position.y - height / 2;
      y += yp;
      double rotation = 0.05;
      xp = x * cos(rotation) - y * sin(rotation);
      yp = y * cos(rotation) + x * sin(rotation);
      xp = xp + width / 2;
      yp = yp + height / 2;
      particle.updatePosition(xp, yp);
    });
  }
}

class Particle {
  static const double GRAVITY = 0.08;
  static const double easing = 0.99;
  double size = PARTICLE_SIZE;
  Point position;
  Point speed;
  String color;

  Particle(this.position, this.speed, this.color);

  void updatePosition(int dx, int dy) {
    position = new Point(dx, dy + GRAVITY);
  }

  void draw() {
    ctx
      ..fillStyle = color
      ..lineWidth = 1
      ..strokeStyle = 'black';

    final int x = position.x - size / 2;
    final int y = position.y - size / 2;

    ctx
      ..fillRect(x, y, size, size)
      ..strokeRect(x, y, size, size);
  }

  String toString() => 'Particle at (${position})';
}
