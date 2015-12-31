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
const int WIDTH = 640;
const int HEIGHT = 480;

Random RNG = new Random();

void main() {
  canvas = querySelector('#canvas');
  ctx = canvas.getContext('2d');

  GameLoopHtmlState initial_state = new InitialState(10);
  GameLoopHtml gameLoop = new GameLoopHtml(canvas);
  gameLoop.state = initial_state;
  gameLoop.start();
}

Point randomizePoint(Point point) {
    int threshold = 50;
    return new Point(point.x + RNG.nextInt(threshold) - threshold / 2, point.y + RNG.nextInt(threshold) - threshold / 2);
}

class InitialState extends SimpleHtmlState {
  List<Particle> particles;

  InitialState(int numParticles) {
    this.particles = new List.generate(numParticles, (e) =>
      new Particle(
        randomizePoint(new Point(WIDTH / 2, HEIGHT / 2)),
        new Point(RNG.nextDouble() * 1 - 0.5, -2.5),
        'salmon'
      )
    );
  }

  void onRender(GameLoop gameLoop) {
    ctx.clearRect(0, 0, WIDTH, HEIGHT);
    particles.forEach((particle) => particle.draw());
  }

  void onUpdate(GameLoop gameLoop) {
    particles.forEach((particle) => particle.updatePosition());
  }
}

class Particle {
  static const double GRAVITY = 0.02;
  static const double easing = 0.99;
  double size = PARTICLE_SIZE;
  Point position;
  Point speed;
  String color;

  Particle(this.position, this.speed, this.color);

  void updatePosition() {
    double y = this.speed.y;
    double x = this.speed.x;
    Point delta = new Point(x, y);
    this.position += delta;
    this.speed = new Point(this.speed.x, this.speed.y + GRAVITY);
    this.size *= easing;
  }

  void updateColor(String color) {
    this.color = color;
  }

  void draw() {
    ctx
      ..fillStyle = this.color
      ..strokeStyle = 'white';

    final int x = this.position.x - this.size / 2;
    final int y = this.position.y - this.size / 2;

    ctx
      ..fillRect(x, y, this.size, this.size)
      ..strokeRect(x, y, this.size, this.size);
  }

  String toString() => 'Particle at (${this.position})';
}
