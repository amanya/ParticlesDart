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

const double PARTICLE_SIZE = 10.0;
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
  List<List<Particle>> particles;
  List<double> angles;
  int width;
  int height;

  InitialState(this.numParticles) {
    _resizeCanvas();
    double x = width / 2 - PARTICLE_SIZE / 2;
    double y = height / 2 - PARTICLE_SIZE / 2;
    int distance = 20;
    double interval = PI / distance;
    angles = new List.generate(distance, (n) => cos(interval * n));
    particles = new List.generate(
        20,
        (n) => _genCircle(new Point(x + n * 5 * angles[n], y + n * 5), 150,
            numParticles, _genColor(distance, n)));
  }

  String _genColor(int distance, int position) {
    double d = (255 / distance) * position;
    return 'rgb(${d.round()},0,0)';
  }

  List<Particle> _genCircle(
      Point center, int radius, int numParticles, String color) {
    double interval = 2 * PI / numParticles;
    return new List.generate(
        numParticles,
        (n) => new Particle(
            new Point(center.x + cos(interval * n) * radius,
                center.y + sin(interval * n) * radius),
            new Point(0, 0),
            color));
  }

  void _resizeCanvas() {
    width = window.innerWidth;
    height = window.innerHeight;
    canvas.width = width;
    canvas.height = height;
  }

  void onRender(GameLoop gameLoop) {
    ctx
      ..fillStyle = "rgb(0,0,0)"
      ..fillRect(0, 0, width, height);
    particles
        .forEach((circle) => circle.forEach((particle) => particle.draw()));
    double fps = 1 / gameLoop.dt;
    drawText(ctx, 'FPS: ${fps.round()}', new Point(20, 20));
  }

  void onUpdate(GameLoop gameLoop) {
    for (var n = 0; n < particles.length; n++) {
      var angle = angles[n];
      angle += .1;
      if (angle >= 2 * PI) {
        angle = 0;
      }
      angles[n] = angle;
      particles[n].forEach((particle) {
        double x = particle.position.x;
        double y = particle.position.y;
        double xp = x + cos(angle) * 5;
        double yp = y + sin(angle) * 5;
        particle.updatePosition(xp, yp);
      });
    }
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

  void updatePosition(double x, double y) {
    position = new Point(x, y);
  }

  void draw() {
    ctx
      ..fillStyle = color
      ..lineWidth = 1
      ..strokeStyle = 'black';

    final double x = position.x - size / 2;
    final double y = position.y - size / 2;

    ctx
      ..fillRect(x, y, size, size)
      ..strokeRect(x, y, size, size);
  }

  String toString() => 'Particle at (${position})';
}
