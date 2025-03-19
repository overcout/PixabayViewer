# Test Assignment for iOS Developer Position

## Task Description

Develop an application with the following functionality:

1. **Text Input Field**:  
   The user enters text into a text field.

2. **Image Feed**:  
   The application displays a feed of 10 elements. Each element contains 2 images fetched from the **Pixabay** service:
   - The **first image** is retrieved from the search result based on the entered text.
   - The **second image** is retrieved from the search result based on the entered text plus the word **"graffiti"** appended at the end.
   - Each image is labeled with the text from the `tags` field in the service's response.

3. **Image Preview**:  
   When an image in the feed is tapped, a full-screen preview of that image opens. The user can switch between the first and second images of the element.

4. **Bonus (Optional)**:  
   Implement pagination for the feed of elements.

---

## Example Requests

For the entered text **"Hamburg"**:

- **Feed of first images**:  
  `https://pixabay.com/api/?key=38738026-cb365c92113f40af7a864c24a&q=Hamburg`

- **Feed of second images**:  
  `https://pixabay.com/api/?key=38738026-cb365c92113f40af7a864c24a&q=Hamburg%20graffiti`

---

## Response Fields to Use

1. **`webformatURL`**:  
   Example:  
   `https://pixabay.com/get/g917d866c1bbfee159680183d8fb05b166a7de426f2c1fec8a3ed60c95e79dd39e0df4cc0fc8e0cea103df1f2c899d9baf17b5a385e82502a014276f917ca21f0_640.jpg`  
   This URL is used to display the image.

2. **`tags`**:  
   Example:  
   `port, building, hamburg`  
   This text is displayed as the image caption.

---

## Notes

- The API key from the example (`38738026-cb365c92113f40af7a864c24a`) can be used for testing.
- Ensure the app is user-friendly and follows best practices for iOS development.

---

# Technical Highlights

## Architecture & Design
The project follows a **Clean VIPER-like architecture**, ensuring a clear separation of concerns. Dependency Injection is used to decouple components, making the code testable and maintainable. Protocol-oriented programming enhances modularity, with **MainInteractor, MainPresenter, and MainViewController** communicating via Swift protocols. This structure adheres to **SOLID principles**, improving scalability and future extensibility.

## Networking & API Handling
The app leverages **Swift Concurrency (async/await)** for parallel API requests, reducing wait times when fetching images. **Pagination** is implemented with seamless infinite scrolling, fetching additional images as needed. **Efficient image caching** minimizes redundant network calls, improving performance and smooth scrolling. Errors are gracefully handled with user-friendly alerts, ensuring a robust user experience.

## UI/UX Implementation
The interface is built using **programmatic Auto Layout**, ensuring flexibility and dynamic content handling. A custom **UITableView-based FormView** supports modular, reusable list components. Tapping an image opens a **full-screen detail view with a smooth paging transition**, allowing users to switch between the original and graffiti image. **Keyboard-aware adjustments** prevent UI overlap, enhancing usability.

## Code Quality & Best Practices
The project adheres to **Swift best practices**, using structured concurrency, closures for event handling, and extensions for modularity. **Cell reuse and lazy image loading** ensure smooth scrolling and optimal memory management. The design prioritizes **testability**, with dependency injection enabling easy mocking for unit tests. Clean, well-documented code makes the project highly maintainable and extendable.
