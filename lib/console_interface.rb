require "colorize"

class ConsoleInterface
  # FIGURES содержит массив содержимого всех файлов из папки figures.
  FIGURES =
      Dir["#{__dir__}/../data/figures/*.txt"]
      .sort
      .map { |file_name| File.read(file_name) }

  # Конструктор класса ConsoleInterface принимает экземпляр класса Game.
  #
  # Экземпляр ConsoleInterface выводит информацию о состоянии игры, использует
  # информацию из экземпляра Game, вызывая его методы.
  def initialize(game)
    @game = game
  end

  # Выводит в консоль текущее состояние игры, используя данные из экземпляра
  # Game (кол-тво ошибок, кол-во оставшихся попыток и т.д.)
  def print_out
    puts <<~END
      Слово: #{word_to_show.colorize(:light_blue)}
      #{figure.colorize(:yellow)}
      Ошибки (#{@game.errors_made}): #{errors_to_show.colorize(:red)}
      У вас осталось ошибок: #{@game.errors_allowed}

    END

    if @game.won?
      puts "Поздравляем, вы выиграли!".colorize(:green)
    elsif @game.lost?
      puts "Вы проиграли, загаданное слово: #{@game.word}".colorize(:red)
    end
  end

  # Возвращает фигуру из массива FIGURES, которая соответствует кол-ву
  # ошибок, сделанных пользователем на данный момент (число ошибок берем у
  # экземпляра Game).
  def figure
    FIGURES[@game.errors_made]
  end

  # Метод, который готовит слово для вывода в консоль.
  #
  # Получает на вход массив: каждый элемент массива соответствует одной букве в
  # загаданном слове, а вместо неотгаданной буквы — nil.
  #
  # Метод трансформирует массив (записывает вместо nil два подчеркивания),
  # и склеивает в строку, разделяя элементы пробелами:
  #
  # На вход передали: ["К", "О", nil, "О", nil, nil],
  # на выходе будет: "К О __ О __ __"
  def word_to_show
    @game.letters_to_guess.map { |letter| letter || "__" }.join(" ")
  end

  # Получает массив ошибочных букв и склеивает их в строку вида "Х, У".
  def errors_to_show
    @game.errors.join(", ")
  end

  # Получает букву из пользовательского ввода, приводит её к верхнему регистру
  # и возвращает её.
  def get_input
    print "Введите следующую букву: "
    letter = gets[0].upcase
    letter
  end
end
