"use client"

import { ShoppingCart, Menu } from "lucide-react"
import { useState } from "react"

interface HeaderProps {
  cartCount: number
  onCartClick: () => void
}

export default function Header({ cartCount, onCartClick }: HeaderProps) {
  const [menuOpen, setMenuOpen] = useState(false)

  return (
    <header className="sticky top-0 z-40 bg-primary text-primary-foreground shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-lg bg-accent flex items-center justify-center font-bold text-lg">📚</div>
            <h1 className="text-4xl font-bold">MithunKrishna</h1>
          </div>

          <nav className="hidden md:flex items-center gap-8">
            <a href="#" className="text-sm hover:opacity-80 transition">
              Home
            </a>
            <a href="#books" className="text-sm hover:opacity-80 transition">
              Books
            </a>
            <a href="#" className="text-sm hover:opacity-80 transition">
              About
            </a>
            <a href="#" className="text-sm hover:opacity-80 transition">
              Contact
            </a>
          </nav>

          <div className="flex items-center gap-4">
            <button
              onClick={onCartClick}
              className="relative p-2 hover:bg-accent/20 rounded-lg transition"
              aria-label="Shopping cart"
            >
              <ShoppingCart className="w-5 h-5" />
              {cartCount > 0 && (
                <span className="absolute -top-1 -right-1 bg-accent text-primary text-xs rounded-full w-5 h-5 flex items-center justify-center font-bold">
                  {cartCount}
                </span>
              )}
            </button>

            <button
              onClick={() => setMenuOpen(!menuOpen)}
              className="md:hidden p-2 hover:bg-accent/20 rounded-lg transition"
              aria-label="Menu"
            >
              <Menu className="w-5 h-5" />
            </button>
          </div>
        </div>

        {menuOpen && (
          <nav className="md:hidden pb-4 flex flex-col gap-3">
            <a href="#" className="text-sm hover:opacity-80 transition">
              Home
            </a>
            <a href="#books" className="text-sm hover:opacity-80 transition">
              Books
            </a>
            <a href="#" className="text-sm hover:opacity-80 transition">
              About
            </a>
            <a href="#" className="text-sm hover:opacity-80 transition">
              Contact
            </a>
          </nav>
        )}
      </div>
    </header>
  )
}
