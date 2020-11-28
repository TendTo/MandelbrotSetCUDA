#include "main.h"

int main()
{
	initWindow();
	return 0;
}

void initWindow()
{
	bool isHUDPressed = false;
	sf::RenderWindow window(sf::VideoMode(WIDTH, HEIGHT), "Mandelbrot set", sf::Style::Fullscreen);
	sf::Vertex* vertices = initVertices();
	ms::Mandelbrot_set mandelbrot(&window, WIDTH, HEIGHT, vertices);

	window.clear();
	mandelbrot.show();

	while (window.isOpen())
	{
		sf::Event event;
		while (window.pollEvent(event))
		{
			if (event.type == sf::Event::Closed || sf::Keyboard::isKeyPressed(sf::Keyboard::Escape))
				window.close();
			if (sf::Mouse::isButtonPressed(sf::Mouse::Button::Left))
			{
				mandelbrot.setPosition(sf::Mouse::getPosition(window).x - (int)(window.getSize().x >> 1), sf::Mouse::getPosition(window).y - (int)(window.getSize().y >> 1));
			}
			if (event.type == sf::Event::MouseWheelMoved)
			{
				if (event.mouseWheel.delta > 0)
					mandelbrot.setZoom(0.9);
				else
					mandelbrot.setZoom(1.1);
			}
			if (sf::Keyboard::isKeyPressed(sf::Keyboard::Up) || sf::Keyboard::isKeyPressed(sf::Keyboard::W)) {
				mandelbrot.setStartY(-100);
			}
			if (sf::Keyboard::isKeyPressed(sf::Keyboard::Down) || sf::Keyboard::isKeyPressed(sf::Keyboard::S)) {
				mandelbrot.setStartY(100);
			}
			if (sf::Keyboard::isKeyPressed(sf::Keyboard::Left) || sf::Keyboard::isKeyPressed(sf::Keyboard::A)) {
				mandelbrot.setStartX(-100);
			}
			if (sf::Keyboard::isKeyPressed(sf::Keyboard::Right) || sf::Keyboard::isKeyPressed(sf::Keyboard::D)) {
				mandelbrot.setStartX(100);
			}
			if (sf::Keyboard::isKeyPressed(sf::Keyboard::Add)) {
				mandelbrot.setZoom(0.9);
			}
			if (sf::Keyboard::isKeyPressed(sf::Keyboard::Subtract)) {
				mandelbrot.setZoom(1.1);
			}
			if (sf::Keyboard::isKeyPressed(sf::Keyboard::R)) {
				mandelbrot.reset();
			}
			if (sf::Keyboard::isKeyPressed(sf::Keyboard::E)) {
				mandelbrot.setIteration(1);
			}
			if (sf::Keyboard::isKeyPressed(sf::Keyboard::Q)) {
				mandelbrot.setIteration(-1);
			}
			if (sf::Keyboard::isKeyPressed(sf::Keyboard::H)) {
				if (!isHUDPressed) {
					isHUDPressed = true;
					mandelbrot.invertHUD();
				}
			}
			else
				isHUDPressed = false;
		}
	}
}

sf::Vertex* initVertices()
{
	sf::Vertex* vertices = new sf::Vertex[WIDTH * HEIGHT];
	for (int x = 0; x < WIDTH; ++x)
	{
		for (int y = 0; y < HEIGHT; ++y) {
			vertices[x + y * WIDTH].position = sf::Vector2f(x, y);
			vertices[x + y * WIDTH].color = sf::Color(x, y, 0);
		}
	}
	return vertices;
}

#if __DEBUG
void fractal(sf::RenderWindow& window, sf::Vertex* vertices, int startX, int startY, double zoom) // 15 * 10^5 micro sec
{
	std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();
	sf::Color color;
	double divX = window.getSize().x / 3.5;
	double divY = window.getSize().y / 2.0;
	for (int x = 0; x < window.getSize().x; ++x)
	{
		for (int y = 0; y < window.getSize().y; ++y)
		{
			double internalX = (x * zoom + startX) / divX - 2.5;
			double internalY = (y * zoom + startY) / divY - 1.0;
			double re = internalX;
			double im = internalY;
			int iteration = 1;
			while (re * re + im * im <= 4 && iteration < MAX_ITER)
			{
				double reTemp = re * re - im * im + internalX;
				im = 2 * re * im + internalY;
				re = reTemp;
				iteration++;
			}
			double iterationNorm = iteration / (double)MAX_ITER;
			color = hsv2rgb_s1(iterationNorm * 360.0, iteration < MAX_ITER ? 1.0 : 0.0);
			vertices[x + y * WIDTH].color = color;
		}
	}
	window.draw(vertices, WIDTH * HEIGHT, sf::Points);
	window.display();
	std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();
	std::cout << "Time enlapsed CPU: " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[microseconds]" << std::endl;
}
#endif