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

#install.packages("qrcode")
url = "link"
qr = qr_code(url)
png("github_profile_qr", width = 1000, height = 1000)
plot(qr)
