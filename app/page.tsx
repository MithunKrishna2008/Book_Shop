"use client"

import { useState } from "react"
import Header from "@/components/header"
import Hero from "@/components/hero"
import BookGrid from "@/components/book-grid"
import Cart from "@/components/cart"
import Footer from "@/components/footer"

export default function Home() {
  const [cartOpen, setCartOpen] = useState(false)
  const [cart, setCart] = useState<
    Array<{ id: string; title: string; author: string; price: number; quantity: number }>
  >([])

  const handleAddToCart = (book: { id: string; title: string; author: string; price: number }) => {
    setCart((prevCart) => {
      const existingBook = prevCart.find((item) => item.id === book.id)
      if (existingBook) {
        return prevCart.map((item) => (item.id === book.id ? { ...item, quantity: item.quantity + 1 } : item))
      }
      return [...prevCart, { ...book, quantity: 1 }]
    })
  }

  const handleRemoveFromCart = (bookId: string) => {
    setCart((prevCart) => prevCart.filter((item) => item.id !== bookId))
  }

  const handleUpdateQuantity = (bookId: string, quantity: number) => {
    if (quantity <= 0) {
      handleRemoveFromCart(bookId)
    } else {
      setCart((prevCart) => prevCart.map((item) => (item.id === bookId ? { ...item, quantity } : item)))
    }
  }

  return (
    <main className="bg-background min-h-screen">
      <Header cartCount={cart.length} onCartClick={() => setCartOpen(!cartOpen)} />
      {cartOpen && (
        <Cart
          cart={cart}
          onClose={() => setCartOpen(false)}
          onUpdateQuantity={handleUpdateQuantity}
          onRemove={handleRemoveFromCart}
        />
      )}
      <Hero />
      <BookGrid onAddToCart={handleAddToCart} />
      <Footer />
    </main>
  )
}
