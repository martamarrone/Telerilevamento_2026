library(imageRy)
library(terra)

# my functions

somma = function(x,y) {
  z = x + y
  return(z)
}
#return è l'output
#il nome di questa funzione è somma
somma(1,2)

differenza = function(x,y) {
  z = x - y
  return(z)
}

sink("data.txt")
loop3()
sink()
#il sink chiude la funzione, come png
#install.packages("qrcode")
url = "link"
qr = qr_code(url)
png("github_profile_qr", width = 1000, height = 1000)
plot(qr)

#cambiare nome a funzioni
mf =function(nx = 1, ny = 2) {
  par(mfrow=c(nx,ny))
  }
#nx = 1 e ny = 2 sono i valori di default
#quindi se so che ho bisogno di fare tante volte questo confronto posso impostare un default e quindi se scrivo solo mf() usa i valori di default
#se non metto =1 e =2 allora non ha valori di default

numeri = function(x) {
  if(x>0) {
  print("Questo numero è positivo")
    }
  else {
   print("Questo numero è negativo")
    }
  }
#per considerare anche lo 0
numeri = function(x) {
  if(x>0) {
  print("Questo numero è positivo")
    }
  else if(x<0) {
  print("Questo numero è negativo")
    }
  else {
  print("È zero")
    }
  }

#ciclo for
#iterazione, quando devo fare lo stesso calcolo per tanti dati
#l'oggetto i potrei chiamarlo come mi pare

loop = function() {
  for(i in 1:5) {
    print(i)
    }
  }

loop2 = function() {
  for(i in 1:15) {
    op = 
    print(op)
    }
  }
#prende tutte le i e moltiplica per 3 
