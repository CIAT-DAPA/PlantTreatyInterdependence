
import os
import csv
import mechanicalsoup
from tqdm import tqdm
from bs4 import BeautifulSoup

### PARAMETROS

userAgent= 'UOCBot/0.1: Mansfel scrapper'
terms_dict = {}
# diccionario de cabecera y campos


##################################################################

def cleanValue(value):
    value = value.replace("\n", "")
    value = value.replace("\r", "")

    return value



def getSpecies(desc, url):
    # crear la lista de convocatorias
    callsList = []


    last =144
    last=2
    progress_bar = tqdm(total=last, desc=desc)

    ### INICIAR LA NAVEGACIÖN


    for use in range(1, last+1):
        browser = mechanicalsoup.StatefulBrowser(user_agent=userAgent)
        browser.open(url)  # se abre la URL
        form = browser.select_form("#wwvFlowForm")
        browser["P8_NUTZID"] = 35

        button = browser.get_current_page().find('input', id='P8_BOTNAM1')
        #form.choose_submit(button)

        soupi = BeautifulSoup(browser.get_current_page().text,"html.parser")
        # create a new tag
        new_tag = soupi.new_tag("input")
        new_tag['id']='P8_BOTNAM1'
        new_tag['type'] = 'submit'
        new_tag['value'] = "Search"
        new_tag['onclick'] = "apex.submit({request:'Go'});"
        # insert the new tag after the current tag
        button.insert_after(new_tag)

        browser.get_current_form().set("p_flow_id", "185", True)
        browser.get_current_form().set("p_flow_step_id", "8", True)
        browser.get_current_form().set("p_instance", "8027718183801", True)

        browser.get_current_form().set("p_reload_on_submit", "A", True)
        browser.get_current_form().set("pSalt", "279827856718052088805285582740706439741", True)


        response = browser.submit_selected()

        soup = BeautifulSoup(response.text, "html.parser")
        rows = soup.findAll("a")
        print(response.url)

        # cerrar el navegador
        browser.close()
        # actualizar la barra de progreso
        progress_bar.update(1)
        # añadiendo delay
        # time.sleep(0.1)

    # cerrar barra de progreso
    progress_bar.close()
    return callsList

def writeCSV(filename, callsList):
    # PARAMETROS ESCRITURA DEL ARCHIVO DE SALIDA
    # directorio actual donde se va a ubicar el archivo
    currentDir = os.path.dirname(__file__)
    # ruta completa del archivo
    filePath = os.path.join(currentDir, filename)
    # separador de columnas
    fieldSeparator = ','

    ### ESCRIBIR ARCHIVO DE SALIDA

    # escribir archivo de salida
    with open(filePath, 'w', newline='', encoding='utf-8') as csvFile:
        # se usa un escritor de diccionarios
        writer = csv.DictWriter(csvFile, delimiter=fieldSeparator, fieldnames=terms_dict, quoting=csv.QUOTE_ALL)

        # escribir cabecera personalizada
        writer.writerow(terms_dict)

        # escribir valores por cada beca
        for call in callsList:
            writer.writerow(call)




##################################################################

# URL de la página del ICETEX a consultar las becas

fileCSV1 = "species.csv"
url1 = "http://mansfeld.ipk-gatersleben.de/apex/f?p=185:8:"
callsList1 = getSpecies(desc=fileCSV1, url=url1)
writeCSV(fileCSV1, callsList1)



##################################################################

