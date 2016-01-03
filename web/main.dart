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

const double PARTICLE_SIZE = 10.0;

Random RNG = new Random();

void main() {
  CanvasElement canvas = querySelector('#canvas');
  CanvasRenderingContext2D canvasContext = canvas.getContext('2d');

  resizeCanvas(canvas);

  GameLoopHtmlState initial_state = new InitialState(canvas, canvasContext, 50);
  GameLoopHtml gameLoop = new GameLoopHtml(canvas);
  gameLoop.state = initial_state;
  gameLoop.start();
}

void drawText(CanvasRenderingContext2D canvaContext, String text, Point position) {
  canvaContext
    ..font = '14px sans-serif'
    ..lineWidth = 3
    ..strokeStyle = "black"
    ..strokeText(text, position.x, position.y)
    ..fillStyle = "white"
    ..fillText(text, position.x, position.y);
}

void resizeCanvas(CanvasElement canvas) {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
}

class InitialState extends SimpleHtmlState {
  final CanvasElement canvas;
  final CanvasRenderingContext2D canvasContext;
  final int numParticles;
  List<Circle> _circles;
  List<double> angles;
  int width;
  int height;

  InitialState(this.canvas, this.canvasContext, this.numParticles) {
    width = canvas.width;
    height = canvas.height;
    double x = width / 2 - PARTICLE_SIZE / 2;
    double y = height / 2 - PARTICLE_SIZE / 2;
    int distance = 20;
    double interval = PI / distance;
    angles = new List.generate(distance, (n) => cos(interval * n));
    _circles = new List.generate(20, (n) => new Circle(new Point(x + n * 5 * angles[n], y + n * 5), 150, numParticles, _genColor(distance, n)));
  }

  String _genColor(int distance, int position) {
    double d = (255 / distance) * position;
    return 'rgb(${d.round()},0,0)';
  }

  void _clearCanvas() {
    canvasContext
      ..fillStyle = "rgb(0,0,0)"
      ..fillRect(0, 0, width, height);
  }

  void onRender(GameLoop gameLoop) {
    _clearCanvas();
    _circles.forEach((circle) => circle.draw(canvasContext));
    double fps = 1 / gameLoop.dt;
    drawText(canvasContext, 'FPS: ${fps.round()}', new Point(20, 20));
  }

  void onUpdate(GameLoop gameLoop) {
    for (var n = 0; n < _circles.length; n++) {
      var angle = angles[n];
      angle += .07;
      if (angle >= 2 * PI) {
        angle = 0;
      }
      angles[n] = angle;
      double xp = cos(angle) * 5;
      double yp = sin(angle) * 5;
      _circles[n].updatePosition(new Point(xp, yp));
    }
  }
}

class Circle {
  Point center;
  double radius;
  int numParticles;
  String color;

  List<Particle> _particles;

  Circle(this.center, this.radius, this.numParticles, String color) {
    double interval = 2 * PI / numParticles;
    _particles = new List.generate(
      numParticles,
      (n) => new Particle(
        new Point(center.x + cos(interval * n) * radius,
                  center.y + sin(interval * n) * radius),
                  color));
  }

  void draw(CanvasRenderingContext2D canvaContext) {
    _particles.forEach((particle) => particle.draw(canvaContext));
  }

  void updatePosition(Point delta) {
    _particles.forEach((particle) => particle.updatePosition(delta));
  }
}

class Particle {
  double size = PARTICLE_SIZE;
  Point position;
  String color;

  Particle(this.position, this.color);

  void updatePosition(Point delta) {
    position += delta;
  }

  void draw(CanvasRenderingContext2D canvasContext) {
    canvasContext
      ..fillStyle = color
      ..lineWidth = 1
      ..strokeStyle = 'black';

    final double x = position.x - size / 2;
    final double y = position.y - size / 2;

    canvasContext
      ..fillRect(x, y, size, size)
      ..strokeRect(x, y, size, size);
  }

  String toString() => 'Particle at (${position})';
}
