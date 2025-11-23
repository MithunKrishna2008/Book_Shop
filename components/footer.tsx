import { Heart } from "lucide-react"

export default function Footer() {
  return (
    <footer className="bg-primary text-primary-foreground py-12 border-t border-border">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
          <div>
            <h3 className="font-bold text-lg mb-4">MithunKrishna Books</h3>
            <p className="text-sm opacity-80">Bringing stories and knowledge to readers everywhere.</p>
          </div>

          <div>
            <h4 className="font-semibold mb-4">Quick Links</h4>
            <ul className="space-y-2 text-sm opacity-80">
              <li>
                <a href="#" className="hover:opacity-100 transition">
                  Home
                </a>
              </li>
              <li>
                <a href="#" className="hover:opacity-100 transition">
                  Books
                </a>
              </li>
              <li>
                <a href="#" className="hover:opacity-100 transition">
                  About Us
                </a>
              </li>
            </ul>
          </div>

          <div>
            <h4 className="font-semibold mb-4">Support</h4>
            <ul className="space-y-2 text-sm opacity-80">
              <li>
                <a href="#" className="hover:opacity-100 transition">
                  Contact
                </a>
              </li>
              <li>
                <a href="#" className="hover:opacity-100 transition">
                  FAQs
                </a>
              </li>
              <li>
                <a href="#" className="hover:opacity-100 transition">
                  Shipping
                </a>
              </li>
            </ul>
          </div>

          <div>
            <h4 className="font-semibold mb-4">Connect</h4>
            <ul className="space-y-2 text-sm opacity-80">
              <li>
                <a href="#" className="hover:opacity-100 transition">
                  Facebook
                </a>
              </li>
              <li>
                <a href="#" className="hover:opacity-100 transition">
                  Instagram
                </a>
              </li>
              <li>
                <a href="#" className="hover:opacity-100 transition">
                  Twitter
                </a>
              </li>
            </ul>
          </div>
        </div>

        <div className="border-t border-primary-foreground/20 pt-8 flex flex-col md:flex-row items-center justify-between gap-4">
          <p className="text-sm opacity-80">© 2025 MithunKrishna Books. All rights reserved.</p>
          <div className="flex items-center gap-1 text-sm opacity-80">
            Made with <Heart className="w-4 h-4 fill-current" /> for book lovers
          </div>
        </div>
      </div>
    </footer>
  )
}
