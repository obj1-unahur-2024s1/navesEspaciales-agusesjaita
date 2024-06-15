class Nave {
	var velocidad = 0
	var dir = 0
	var combustible = 0
	
	method direccion(num) {dir = if (num.isBetween(-10, 10)) num else {}} 
	
	method acelerar(cuanto) {velocidad = 100000.min(velocidad + cuanto)}
	
	method desacelerar(cuanto) {velocidad = 0.max(velocidad - cuanto)}
	
	method irHaciaElSol() {dir = 10}
	
	method escaparDelSol() {dir = -10}
	
	method ponerseParaleloAlSol() {dir = 0}
	
	method acercarseUnPocoAlSol() {dir = 10.min(dir + 1)}
	
	method alejarseUnPocoDelSol() {dir = -10.max(dir + 1)}
	
	method cargarCombustible(cantidad) {combustible =+ cantidad}
	
	method descargarCombustible(cantidad) {combustible =- cantidad}
	
	method prepararViaje() {
		self.cargarCombustible(3000)
		self.acelerar(5000)
	}
	
	method estaTranquila() = combustible >= 4000 and velocidad <= 12000
	
	method recibirAmenaza() {}
	
	method estaDeRelajo() = self.estaTranquila()
}

class NaveBaliza inherits Nave {
	var property colorBaliza = ''
	var cambiosDeColor = 0
	
	method cambiarColorDeBaliza(unColor) {
		colorBaliza = unColor
		cambiosDeColor =+ 1
	}
	
	override method prepararViaje() {
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
		cambiosDeColor =+ 1
	}
	
	override method estaTranquila() {
		cambiosDeColor =+ 1
		return super() and colorBaliza != "rojo" 
	}
	
	override method recibirAmenaza() {
		self.irHaciaElSol() self.cambiarColorDeBaliza("rojo")
		cambiosDeColor =+ 1
	}
	
	override method estaDeRelajo() = super() and cambiosDeColor == 0
}

class NavePasajeros inherits Nave {
	var property pasajeros = 0
	var comida = 0
	var bebida = 0
	var comidaServida = 0
	
	method cargarComida(cantidad) {comida = comida + cantidad}
	
	method descargarComida(cantidad) {comida = 0.max(comida + cantidad)}
	
	method cargarBebidas(cantidad) {bebida = bebida + cantidad}
	
	method descargarBebidas(cantidad) {bebida = 0.max(bebida - cantidad)}
	
	override method prepararViaje() {
		super()
		self.cargarComida(4 * pasajeros)
		self.cargarBebidas(6 * pasajeros)
		self.acercarseUnPocoAlSol()
	}

	override method recibirAmenaza() {
		self.acelerar(velocidad * 2) 
		self.descargarBebidas(2 * pasajeros)
		self.descargarComida(pasajeros)
		comidaServida =+ pasajeros
	}
	
	override method estaDeRelajo() = super() and comidaServida < 50
}

class NaveCombate inherits Nave {
	var estado = ''
	var misiles = true
	const mensajes = []
	
	method ponerseVisible() {estado = "visible"}
	
	method ponerseInvisible() {estado = "invisible"}
	
	method estaVisible() = estado
	
	method desplegarMisiles() {misiles = true}
	
	method replegarMisiles() {misiles = false}
	
	method misilesDesplegados() = misiles
	
	method emitirMensaje(mensaje) {mensajes.add(mensaje)}
	
	method mensajesEmitidos() = mensajes
	
	method primerMensajeEmitido() = mensajes.first()
	
	method ultimoMensajeEmitido() = mensajes.last()
	
	method esEscueta() = mensajes.all({mensaje => mensaje.lenght() < 30})
	
	method emitioMensaje(mensaje) = mensajes.any({msj => msj == mensaje}) 	
	
	override method prepararViaje() {
		super()
		self.ponerseInvisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en mision")
	}

	override method estaTranquila() = super() and not misiles
	
	override method recibirAmenaza() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method estaDeRelajo() = super() and self.esEscueta()
}

class NaveHospital inherits NavePasajeros {
	var property quirofanosPreparados = false
	
	override method estaTranquila() = super() and not quirofanosPreparados
	
	override method recibirAmenaza() {super() self.quirofanosPreparados(true)}
}

class NaveCombateSigilosa inherits NaveCombate {
	
	override method estaTranquila() = super() and estado == "visible"
	
	override method recibirAmenaza() {super() self.desplegarMisiles() self.ponerseInvisible()}
}
