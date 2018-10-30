import time
import csv
import os
from urllib.parse import urljoin

import requests
from bs4 import BeautifulSoup
from tqdm import tqdm

### PARAMETROS

userAgent = "UOCBot/0.1: UPOV PLUTO Web Scrapper"
url_1 = "https://www3.wipo.int/authpage/signin.xhtml?goto=https%3A%2F%2Fwww3.wipo.int%3A443%2Fpluto%2Fuser%2Fen%2Findex.jsp"
url_2 = "https://www3.wipo.int/authpage/signin.xhtml"
url_3= "https://www3.wipo.int/pluto/user/jsp/select.jsp"
speciesCSV = "pluto.accessions.json"
separator = '\t'
equals = "="
properties = {}


def cleanValue(value):
    value = value.replace("\n", "")
    value = value.replace("\r", "")
    value = value.replace(separator, " ")

    return value



def getSpecies(desc):
    # crear la lista de taxones


    progress_bar = tqdm(total=1, desc=desc)

    ### INICIAR LA NAVEGACIÓN

    with open(speciesCSV, 'w', encoding="utf-8") as file:

        s = requests.Session()
        s.headers = {"User-Agent": userAgent}
        response_1 = s.get(url_1)
        soup = BeautifulSoup(response_1.text, "lxml")



        values_2 = {
            'authform': 'authform',
            'authform_authStateId': soup.select_one("[name='authform_authStateId']")['value'],
            'authform_fields:0:authform_text': properties.get("user"),
            'authform_fields:1:authform_mask': properties.get("password"),
            'authform_signin': soup.select_one("[name='authform_signin']")['value'],
            'javax.faces.ViewState': soup.select_one("[name='javax.faces.ViewState']")['value']

        }


        s.headers.update({'Referer': url_1})

        response_2 = s.post(url_2, data=values_2)

        values_3 = {
            'qz': 'N4IgLgngDgpiBcICuUD2A3EAaEAbAhgiDAHbYgCOAlkQAwC0A7ACYBCAygEYDOA1uuyQBFAExIKjRgAlOASQCiATWYUATo1ncAGgCsA7gBlGegMwBVeVQAetWQA5UAcwC8IAL5AA',
        }

        response_3 = s.post(url_3, data=values_3)

        soup_3 = BeautifulSoup(response_3.text, "lxml")

        file.write(response_3.text)


        file.flush()
        # update progress bar
        progress_bar.update(1)
        # adding delay
        time.sleep(0.5)

    file.close()
    # close progress bar
    progress_bar.close()



def writeItemCSV(filename, items):
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
        w = csv.DictWriter(csvFile, fieldnames=items.keys(), delimiter=fieldSeparator, quoting=csv.QUOTE_ALL)
        w.writeheader()
        w.writerow(items)



def loadCredentials(filename):

    with open(filename) as f:

        for line in f:
            if equals in line:

                name, value = line.split(equals, 1)

                properties[name.strip()] = value.strip()



##################################################################

loadCredentials('credentials.properties')

species = getSpecies(desc='accesions')

##################################################################
