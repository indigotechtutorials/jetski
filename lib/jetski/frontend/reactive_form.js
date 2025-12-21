let reactiveFormELS = document.querySelectorAll("[reactive-form-path]")
reactiveFormELS.forEach(reactiveFormElement => {
  reactiveFormElement.addEventListener("change", () => {
    let reactiveFormURL = reactiveFormElement.getAttribute("reactive-form-path")
    fetch(reactiveFormURL, {
      body: JSON.stringify({
        content: reactiveFormURL.value,
      }),
      method: "POST",
    })
  })
})