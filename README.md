# LoadingDots

Simple loading dots view, light and quite configurable.

## Simple use example

    let dotsView = LoadingDotsView()
	dotsView.translatesAutoresizingMaskIntoConstraints = false
	addSubview(dotsView)
	NSLayoutConstraint.activate([
		dotsView.centerXAnchor.constraint(equalTo: centerXAnchor),
		dotsView.centerYAnchor.constraint(equalTo: centerYAnchor)
	])

## Configuration options

 - **Number of dots**
 - **Dot radius:** Actually, it is the dot diameter.
 - **Dot separation:** Separation between dots.
 - **Colors:** Background color of the dots. If the array containts more than one color, a gradient will be added with those colors. If contains one color, no gradient will be created, just the color.
 - **Animation:** The desired animation from the available options.

## Available animations

### Opacity

![opacity](https://github.com/AlvaroOlave/LoadingDots/assets/11005083/8c7e06f4-69b3-455a-92f2-f7508a2c8c65)

### OpacityWave

![opacityWave](https://github.com/AlvaroOlave/LoadingDots/assets/11005083/d25b53ea-9d23-451f-9d31-8576d3a6ffb4)

### Scale

![scale](https://github.com/AlvaroOlave/LoadingDots/assets/11005083/cc0026ab-9793-4a7c-8ce6-eab16a81aafb)

### ScaleWave

![scaleWave](https://github.com/AlvaroOlave/LoadingDots/assets/11005083/d4aab452-2411-441f-b4dc-63effda6bb61)

### Bounce

![bounce](https://github.com/AlvaroOlave/LoadingDots/assets/11005083/7c9c4438-8a45-436e-86a4-b9b2ab43b354)

### Pendulum Bounce

![bouncePend](https://github.com/AlvaroOlave/LoadingDots/assets/11005083/d0da1a2d-b814-4544-8016-4cd6b04979df)
