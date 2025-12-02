function openNav() {
  document.getElementById("mySidebar").style.width = "250px";
  document.querySelector(".main-wrapper").style.marginLeft = "250px"; // push content
}

function closeNav() {
  document.getElementById("mySidebar").style.width = "0";
  document.querySelector(".main-wrapper").style.marginLeft = "0"; // reset content
}

//function for the index //
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
   const firstSrc = "Web_interface/IMG/183631020.png";
   const secondSrc = "Web_interface/IMG/team_paul_petit.png";

   img.src = (img.src.includes("183631020.png")) ? secondSrc : firstSrc;
}
