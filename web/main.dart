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
const String PARTICLE_COLOR = 'salmon';
const int WIDTH = 640;
const int HEIGHT = 480;

Random RNG = new Random();

void main() {
  canvas = querySelector('#canvas');
  ctx = canvas.getContext('2d');

  GameLoopHtmlState initial_state = new InitialState(1000);
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
  final int maxParticles;
  List<Particle> particles = [];

  InitialState(this.maxParticles);

  void onRender(GameLoop gameLoop) {
    ctx
      ..fillStyle = "rgb(0,0,0)"
      ..fillRect(0, 0, WIDTH, HEIGHT);
    particles.forEach((particle) => particle.draw());
    double fps = 1 / gameLoop.dt;
    drawText(ctx, 'FPS: ${fps.round()}', new Point(20, 20));
  }

  void onUpdate(GameLoop gameLoop) {
    if(particles.length < maxParticles) {
      particles.add(new Particle.randomInitialize());
    }
    particles.forEach((particle) => particle.updatePosition());
  }
}

class Particle {
  static const double GRAVITY = 0.98;
  static const double easing = 0.98;
  double size = PARTICLE_SIZE;
  Point position;
  Point speed;
  String color;

  Particle(this.position, this.speed, this.color);
  Particle.randomInitialize() {
    _initialSetup();
  }

  void _initialSetup() {
    size = PARTICLE_SIZE;
    position = _randomizePoint(new Point(WIDTH / 2, HEIGHT - size), 30);
    speed = _randomizePoint(new Point(RNG.nextDouble() * 10 - 5, -20), 3);
    color = PARTICLE_COLOR;
  }

  Point _randomizePoint(Point point, int threshold) {
    return new Point(point.x + RNG.nextInt(threshold) - threshold / 2,
        point.y + RNG.nextInt(threshold) - threshold / 2);
  }



  void updatePosition() {
    double y = speed.y;
    double x = speed.x;
    Point delta = new Point(x, y);
    position += delta;
    if(position.y >= HEIGHT - size) {
      position = new Point(position.x, HEIGHT - size);
      speed = new Point(0, 0);
    } else {
      speed = new Point(speed.x, speed.y + GRAVITY);
    }
    size *= easing;
    if(size <= 1) {
      _initialSetup();
    }
  }

  void updateColor(String color) {
    this.color = color;
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
