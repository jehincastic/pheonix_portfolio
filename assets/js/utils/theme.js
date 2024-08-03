export const changeTheme = async (nextTheme) => {
	const element = document.getElementById("light-theme-icon") || document.getElementById("dark-theme-icon")
	await document.startViewTransition(() => {
		document.documentElement.className = nextTheme
	}).ready

	const { top, left } = element.getBoundingClientRect()
	const x = left
	const y = top
	const right = window.innerWidth - left
	const bottom = window.innerHeight - top
	// Calculates the radius of circle that can cover the screen
	const maxRadius = Math.hypot(
		Math.max(left, right),
		Math.max(top, bottom),
	)

	document.documentElement.animate(
		{
			clipPath: [
				`circle(0px at ${x}px ${y}px)`,
				`circle(${maxRadius}px at ${x}px ${y}px)`,
			],
		},
		{
			duration: 500,
			easing: "ease-in-out",
			pseudoElement: "::view-transition-new(root)",
		}
	)
}
