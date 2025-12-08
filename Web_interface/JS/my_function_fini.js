function openNav() {
  document.getElementById("mySidebar").style.width = "15%";
  document.querySelector(".main-wrapper").style.marginLeft = "15%"; // push content
}

function closeNav() {
  document.getElementById("mySidebar").style.width = "0";
  document.querySelector(".main-wrapper").style.marginLeft = "0"; // reset content
}

function toggleDocumentList() {
             const documentList = document.getElementById('documentList');
             if  (documentList.style.display === 'none' || documentList.style.display === '') {
                 documentList.style.display = 'block';
             } else {
                 documentList.style.display = 'none';
             }
         }

function toggleWebList() {
             const documentList = document.getElementById('webList');
             if  (documentList.style.display === 'none' || documentList.style.display === '') {
                 documentList.style.display = 'block';
             } else {
                 documentList.style.display = 'none';
             }
         }

function toggleImageSource() {
   const img = document.getElementById("toggleImage");
   const firstSrc = "Web_interface/IMG/Paul_in_the_matrix.png";
   const secondSrc = "Web_interface/IMG/team_paul_petit.png";

   img.src = (img.src.includes("Paul_in_the_matrix.png")) ? secondSrc : firstSrc;
}

function toggleTOC() {
  var tocList = document.querySelector('.toc_list');
  var tocContainer = document.getElementById('toc_container');

  // Toggle list visibility
  var isVisible = tocList.style.display === "block";
  tocList.style.display = isVisible ? "none" : "block";

  // Toggle grey background
  if (isVisible) {
    tocContainer.classList.remove('active');
  } else {
    tocContainer.classList.add('active');
  }
}

function toggleSubPoints(headerLink) {
  var subList = headerLink.nextElementSibling;
  if (subList && subList.tagName === "UL") {
    subList.style.display = (subList.style.display === "none") ? "block" : "none";
  }
}
