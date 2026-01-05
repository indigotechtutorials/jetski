let reactiveFormELS = document.querySelectorAll("[reactive-form-path]")
reactiveFormELS.forEach(reactiveFormElement => {
  reactiveFormElement.addEventListener("input", () => {
    let reactiveFormURL = reactiveFormElement.getAttribute("reactive-form-path")
    fetch(reactiveFormURL, {
      body: JSON.stringify({
        content: reactiveFormElement.value,
      }),
      method: "POST",
    })
  })
})