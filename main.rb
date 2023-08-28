require 'net/http'
require 'json'
require 'csv'

def buscar_fruta(valor, criterios)
  criterios.each do |criterio|
    api_url = URI("https://www.fruityvice.com/api/fruit/#{criterio}/#{valor}")
    response = Net::HTTP.get(api_url)
    data = JSON.parse(response)
    return data if data.is_a?(Array) && data.size > 0
  end
  nil
end

def buscar_fruta_por_nombre(nombre)
  api_url = URI("https://www.fruityvice.com/api/fruit/#{nombre}")
  response = Net::HTTP.get(api_url)
  data = JSON.parse(response)
  data.key?('id') ? data : nil
end

def guardar_en_archivo_csv(nombre_archivo, frutas)
  CSV.open(nombre_archivo, 'a') do |csv|
    frutas.each do |fruta|
      datos_fruta = []
      fruta.each do |campo, valor|
        if campo == 'nutritions'
          valor.each do |nutricion, cantidad|
            datos_fruta << "#{nutricion}:#{cantidad}"
          end
        else
          datos_fruta << "#{campo}:#{valor}"
        end
      end
      csv << datos_fruta
    end
  end
  puts "Datos de las frutas guardados en '#{nombre_archivo}'."
end

def buscar_por_nombre
  puts "Ingresa el nombre de la fruta que deseas buscar:"
  nombre_fruta = gets.chomp.downcase
  fruta_encontrada = buscar_fruta_por_nombre(nombre_fruta)
  if fruta_encontrada
    puts "Ingresa el nombre del archivo para guardar los datos (sin la extensión .csv):"
    nombre_archivo = gets.chomp
    nombre_archivo += '.csv' unless nombre_archivo.downcase.end_with?('.csv')
    guardar_en_archivo_csv(nombre_archivo, [fruta_encontrada])
  else
    puts "No se encontró la fruta con el nombre proporcionado."
  end
end

def buscar_por_criterio
  criterios = ['order', 'family', 'genus']
  puts "Ingresa el término de búsqueda, por ejemplo:"
  puts "family=(rosaceae)"
  puts "genus=(fragaria)"
  puts "order=(rosales)"
  termino_busqueda = gets.chomp.downcase
  frutas_encontradas = buscar_fruta(termino_busqueda, criterios)
  if frutas_encontradas
    puts "Ingresa el nombre del archivo para guardar los datos (sin la extensión .csv):"
    nombre_archivo = gets.chomp
    nombre_archivo += '.csv' unless nombre_archivo.downcase.end_with?('.csv')
    guardar_en_archivo_csv(nombre_archivo, frutas_encontradas)
  else
    puts "No se encontraron frutas para el término de búsqueda proporcionado."
  end
end

def main
  puts "¿Quieres buscar por nombre o por criterio? (nombre/criterio)"
  tipo_busqueda = gets.chomp.downcase
  if tipo_busqueda == "nombre"
    buscar_por_nombre
  elsif tipo_busqueda == "criterio"
    buscar_por_criterio
  else
    puts "Opción no válida. Debes seleccionar 'nombre' o 'criterio'."
  end
end

main