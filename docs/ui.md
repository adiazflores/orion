# Naming Convetion

##### Extensions

Use .js extension for React components.

##### Filename

Use PascalCase for filenames. E.g., `ReservationCard.jsx`.

##### Reference Naming

Use PascalCase for React components and camelCase for their instances. eslint: react/jsx-pascal-case. E.g., import ReservationCard from `'./ReservationCard'`

##### Component Naming

Use the filename as the component name. For example, ReservationCard.jsx should have a reference name of ReservationCard. However, for root components of a directory, use index.jsx as the filename and use the directory name as the component name. E.g., `import Footer from './Footer'`

##### Higher-order Component Naming

Use a composite of the higher-order component’s name and the passed-in component’s name as the displayName on the generated component. For example, the higher-order component withFoo(), when passed a component Bar should produce a component with a displayName of withFoo(Bar).

##### Props Naming\*\* Avoid using DOM component prop names for different purposes.

E.g., `<MyComponent variant="fancy" />`

\*See the full naming airbnb's reference: `<link>` : <https://github.com/airbnb/javascript/tree/master/react#naming>

# Folder Structure

```
src
│   App.css
│   App.js
|   App.test.js
|   index.css
|   index.js
|   logo.svg
│
└───components
│   │   index.js
│   │   styles.scss
│   │   InnerComponent.js
│   └───Component1
│   |   │   index.jsx
│   |   │   styles.scss
|   |   |   InnerComponent1.js
|   |   |   InnerComponent2.js
│   |   │   ...
|   └───common
│       └───Component1
│       │   index.js
│       │   styles.scss
|       |   InnerComponent.js
|       |   InnerComponent2.js
│       │   ...
|
└───lib/img
    │   icon@2x.png
    │   icon@2x.png
```
