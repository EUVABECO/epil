function addLanguage(display,item,language) {
 row = display.insertRow(-1)
 row.className = "language"
   row.insertCell(-1)
   spelabel = row.insertCell(-1)
   spelabel.innerHTML = `${item['label'][language]}`
   ePIL = row.insertCell(-1)
   if (language in item['ePIL']) {
     ePIL.innerHTML = `<a href="${item['ePIL'][language]}" target="_blank">${language}</a>`
   }
   SmPC = row.insertCell(-1)
   if (language in item['SmPC']) {
     SmPC.innerHTML = `<a href="${item['SmPC'][language]}" target = "_blank">${language}</a>` 
   }
}

function addPresentation(display,index,item) {
	row = display.insertRow(-1)
	row.className = "presentation"
	i = row.insertCell(-1)
        i.colSpan = 2
        i.innerHTML = index
	ePILs = row.insertCell(-1)
	SmPCs = row.insertCell(-1)			
        for (language in item['label']) {
	  addLanguage(display,item,language)
        }
}
function addVaccine(display,vaccine, label, presentations) {
	row = display.insertRow(-1)
	row.className = "vaccine"
	vcode = row.insertCell(-1)
	vcode.innerHTML = vaccine
	vlabel = row.insertCell(-1)
	vlabel.colSpan = "3"
	vlabel.innerHTML = label		

	for (index in presentations) {
		addPresentation(display,index,presentations[index])
	}
}

function initTable(){
	var table = document.createElement("table")
	row = table.insertRow(-1)
	row.className = "header"
	row.insertCell(-1).innerHTML='Code'
	row.insertCell(-1).innerHTML='Product'
	row.insertCell(-1).innerHTML='ePIL'
	row.insertCell(-1).innerHTML='SmPC'
	return (table)
}

function addAll(display,vaccines,labels) {
for (vaccine in vaccines ) {
	addVaccine(display,vaccine,labels[vaccine], vaccines[vaccine])
}
}
