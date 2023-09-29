document.addEventListener("DOMContentLoaded", function () {
  const toggleButtons = document.querySelectorAll(".toggle-table");

  toggleButtons.forEach((button) => {
    button.addEventListener("click", (event) => {
      event.preventDefault();
      const targetId = event.target.getAttribute("data-target");
      const targetTable = document.getElementById(targetId);

      if (targetTable) {
        document.querySelectorAll("table.hidden-table").forEach((table) => {
          table.style.display = "none";
        });

        targetTable.style.display = "table";
      }
    });
  });

  const firstTable = document.querySelector("table.hidden-table");
  if (firstTable) firstTable.style.display = "table";
});
