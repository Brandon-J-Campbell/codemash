# Exercise 16-hooks

## React Hooks

This exercise will give you hands-on experience converting code to use the upcoming React hooks API. Hooks will simplify how we use several React features that we've already seen.

👉 Start the app for Exercise 16-hooks

In a console window, pointed at the root of this project, run `npm run start-exercise-16-hooks`.

This will open a browser window pointed at localhost:3000, showing a web app titled "Exercise 16-hooks: Hooks", our three adorable kitten friends, and a theme switcher that toggles between purple and green themes. If it doesn't, ask your neighbor for assistance or raise your hand.

### FriendFlipperBack and FriendFlipperFront: New Components

We've refactored the FriendFlipper component, extracting the `renderBack()` and `renderFront()` functions into `FriendFlipperBack` and `FriendFlipperFront` components. This will help us focus on the changes we're making.

### Rethinking State Management: `useState()`

#### Convert FriendFlipper.js

### Rethinking Lifecycle Events: `useEffect()`

#### Convert Friends.entry.js

### Rethinking Context: `useContext()`

#### Convert Switcher.js

### Extra Credit

The following components could also be converted to use hooks:

- friend-detail/FriendDetail.entry.js (`useState`, `useEffect`)
- friend-detail/FriendFlipperBack.js (`useContext`)
- friend-detail/FriendFlipperFront.js (`useContext`)
- theme/Provider.js (`useState`)
