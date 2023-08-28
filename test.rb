puts "introduce tu nombre"
name = gets.chomp
require 'minitest/autorun'
require_relative 'main.rb'

class TestFrutaBuscador < Minitest::Test
  def setup
    # Puedes inicializar variables o configuraciones aquí si es necesario
  end

  def test_buscar_fruta_por_nombre_existente
    fruta = buscar_fruta_por_nombre('Strawberry')
    refute_nil fruta
    assert_equal 'Strawberry', fruta['name']
  end

  def test_buscar_fruta_por_nombre_no_existente
    fruta = buscar_fruta_por_nombre('fruta_inexistente')
    assert_nil fruta
  end

  def test_buscar_fruta_por_criterio_existente
    frutas = buscar_fruta('Rosaceae', ['family'])
    refute_nil frutas
    assert_equal 'Rosaceae', frutas[0]['family']
  end

  def test_buscar_fruta_por_criterio_no_existente
    frutas = buscar_fruta('criterio_inexistente', ['family'])
    assert_nil frutas
  end

    guardar_en_archivo_csv('test.csv', [fruta])
    archivo = CSV.read('test.csv')
    assert_equal 1, archivo.length
    assert_equal fruta['name'], archivo[0][1]
  end
end
