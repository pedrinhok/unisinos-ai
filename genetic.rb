GENERATIONS_NUM = 5
POPULATION_NUM = 5
MUTATION_PROB = 0.25

class Chromosome

  attr_accessor :genes

  def initialize(genes: nil)
    @genes = genes || seed()
  end

  def seed
    (0..1).map{ rand(-100..100).round(3) }
  end

  def gene(index)
    @genes.fetch(index)
  end

  def fitness()
    # @genes.reduce(0){ |amount, gene| amount += gene * gene }.round(3)
    response = 0
    response += Math.sin(gene(0) ** 3)
    response += Math.sqrt(gene(0) ** 2)
    response += Math.sin(gene(1)) * 3
    response += Math.sqrt(Math.sqrt(Math.sqrt((gene(0) ** 2) + (gene(1) ** 2))))
    response.round(3)
  end

  def crossover(chromosome)
    @genes = @genes.map.with_index{ |gene, index| ((gene + chromosome.gene(index)) / 2).round(3) }
  end

  def mutation()
    num = rand(0.75..1.25).round(3)
    @genes = @genes.map.with_index{ |gene, index| (gene * num).round(3) }
  end

end

class Population

  attr_accessor :chromosomes

  def initialize(chromosomes: nil)
    @chromosomes =  chromosomes || (1..POPULATION_NUM).map{ Chromosome.new() }
  end

  def update()
    current = @chromosomes.map(&:dup)
    best = get_best(@chromosomes)
    @chromosomes.map do |chromosome|
      next if chromosome == best
      # selection
      choosen = current.sample(3)
      choosen = get_best(choosen)
      # crossover
      chromosome.crossover(choosen)
      # mutation
      chromosome.mutation() if rand(0.0..1.0) <= MUTATION_PROB
    end
  end

end

# get best chromosome by fitness
def get_best(chromosomes)
  chromosomes.min_by(&:fitness)
end

# show population
def show(population)
  population.chromosomes.map.with_index do |chromosome, index|
    puts("C#{index + 1} (#{chromosome.gene(0)}, #{chromosome.gene(1)}) -> #{chromosome.fitness}")
  end
end

# run genetic
def run(population)
  # get best chromosome
  chromosome = get_best(population.chromosomes)
  # show generation
  puts("########## INIT POPULATION (#{chromosome.fitness}) ##########")
  # show population
  show(population)
  # run generations
  (1..GENERATIONS_NUM).each do |generation|
    # update population (selection, crossover, mutation)
    population.update()
    # get best chromosome
    chromosome = get_best(population.chromosomes)
    # show generation
    puts("########## #{generation} GENERATION (#{chromosome.fitness}) ##########")
    # show population
    show(population)
  end
end

# create population
population = Population.new
# run genetic
run(population)
