function openNav() {
    document.getElementById("mySidebar").style.width = "250px";
    document.getElementById("main").style.marginLeft = "250px";
}
                    
function closeNav() {
  const sidebar = document.getElementById("mySidebar");
  const main = document.getElementById("main");
  sidebar.style.width = "0";
  main.style.marginLeft = "0";
}

function toggleDocumentList() {
             const documentList = document.getElementById('documentList');
             if  (documentList.style.display === 'none' || documentList.style.display === '') {
                 documentList.style.display = 'block';
             } else {
                 documentList.style.display = 'none';
             }
         }
