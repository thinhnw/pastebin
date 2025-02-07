# Pastebin Clone

This is a simple Pastebin clone built with Ruby on Rails. Users can create and share text-based pastes with syntax highlighting for various programming languages. 

Check out the [Demo](https://pastebin.thinhnw.site) of the app.

## Features

- **Create Paste**: Share text snippets with a specific language.
- **View Raw Paste**: View raw paste content without formatting.
- **Copy Paste**: Easily copy the paste content to your clipboard.
- **Delete Paste**: Remove pastes that are no longer needed.




## Setup

1. **Clone the repository**: 
   ```bash
   git clone https://github.com/thinhnw/pastebin.git
   ```

2. **Install dependencies**: 
   ```bash
   bundle install
   ```

3. **Set up the database**: 
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   ```

4. **Start the server**: 
   ```bash
   bin/rails server
   ```

## Usage

1. Visit [http://localhost:3000](http://localhost:3000) in your browser.
2. Create a new paste by clicking the "Create paste" button.
3. Share your paste with others by copying the url.
4. View raw paste content by selecting the "view raw" option.
5. Delete pastes that are no longer needed using the "Destroy" button.
