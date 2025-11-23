export default function Hero() {
  return (
    <section className="bg-gradient-to-br from-primary via-secondary to-primary/80 text-primary-foreground py-20 md:py-32">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h2 className="text-4xl md:text-5xl font-bold mb-6">Discover Your Next Great Read</h2>
        <p className="text-lg md:text-xl opacity-90 max-w-2xl mx-auto mb-8">
          Handpicked books from every genre. Build your perfect collection with MithunKrishna Books.
        </p>
        <button className="bg-accent text-accent-foreground px-8 py-3 rounded-lg font-semibold hover:shadow-lg transition">
          Explore Collection
        </button>
      </div>
    </section>
  )
}
