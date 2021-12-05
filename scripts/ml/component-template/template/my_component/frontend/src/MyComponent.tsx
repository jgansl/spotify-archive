import {
  Streamlit,
  StreamlitComponentBase,
  withStreamlitConnection,
} from "streamlit-component-lib"
import React, { ReactNode } from "react"

import SearchBar from './subcomponents/search'

interface State {
  numClicks: number
  isFocused: boolean
  data: any
  keyword: string
  results: any
}

/**
 * This is a React-based component template. The `render()` function is called
 * automatically when your component should be re-rendered.
 */
class MyComponent extends StreamlitComponentBase<State> {
  public state = { 
    numClicks: 0, 
    isFocused: false,
    data: [
      { name: "Andrew R. Kelly", age: 22, position: "Janitor" },
      { name: "Adrian Sanchez", age: 30, position: "Teacher" },
      { name: "Anderson Brown", age: 25, position: "Principal" },
      { name: "Anna Valio", age: 30, position: "guidance councelor" },
      { name: "Asha Mathews", age: 50, position: "Teacher" },
      { name: "Alicia keys", age: 25, position: "Librarian" },
      { name: "Alexa Dot", age: 30, position: "teacher" },
      { name: "Bob Squarepants", age: 20, position: "secretary" },
    ],
    keyword: "",
    results: []
  
  }

  matchName = (name: string, keyword: string): boolean => {
    var keyLen = keyword.length;
    name = name.toLowerCase().substring(0, keyLen);
    if (keyword === "") return false;
    return name === keyword.toLowerCase();
  };

  onSearch = async (text:string) => {
    if (text !== "") {
      var stockData, data;
      try {
        stockData = await fetch(
          `https://financialmodelingprep.com/api/v3/search?query=${text}&limit=10&exchange=NASDAQ`
        );
        data = await stockData.json();
      } catch (err) {
        console.log(err.message);
      }

      this.setState({ results: data });
    } else this.setState({ results: [] });
  };

  //https://medium.com/@vincentnewkirk/typing-dynamic-object-keys-with-ts-de0d5990a58e

  //https://github.com/DefinitelyTyped/DefinitelyTyped/issues/26635
  updateField = (field:any, value:any, update:boolean = true): void => {
    if (update) this.onSearch(value);
    this.setState<never>({ [field]: value });
  };


  public render = (): ReactNode => {
    // Arguments that are passed to the plugin in Python are accessible
    // via `this.props.args`. Here, we access the "name" arg.
    const name = this.props.args["name"]

    let { results, keyword } = this.state;

    // Streamlit sends us a theme object via props that we can use to ensure
    // that our component has visuals that match the active theme in a
    // streamlit app.
    const { theme } = this.props
    const style: React.CSSProperties = {}

    // Maintain compatibility with older versions of Streamlit that don't send
    // a theme object.
    if (theme) {
      // Use the theme object to style our button border. Alternatively, the
      // theme style is defined in CSS vars.
      const borderStyling = `1px solid ${
        this.state.isFocused ? theme.primaryColor : "gray"
      }`
      style.border = borderStyling
      style.outline = borderStyling
    }

    // Show a button and some text.
    // When the button is clicked, we'll increment our "numClicks" state
    // variable, and send its new value back to Streamlit, where it'll
    // be available to the Python program.
    return (
      <>
      <span>
        Hello, {name}! &nbsp;
        <button
          style={style}
          onClick={this.onClicked}
          disabled={this.props.disabled}
          onFocus={this._onFocus}
          onBlur={this._onBlur}
        >
          Click Me!
        </button>
      </span>
      <SearchBar
          results={results}
          keyword={keyword}
          updateField={this.updateField}
        />
        </>
    )
  }

  /** Click handler for our "Click Me!" button. */
  private onClicked = (): void => {
    // Increment state.numClicks, and pass the new value back to
    // Streamlit via `Streamlit.setComponentValue`.
    this.setState(
      prevState => ({ numClicks: prevState.numClicks + 1 }),
      () => Streamlit.setComponentValue(this.state.numClicks)
    )
  }

  /** Focus handler for our "Click Me!" button. */
  private _onFocus = (): void => {
    this.setState({ isFocused: true })
  }

  /** Blur handler for our "Click Me!" button. */
  private _onBlur = (): void => {
    this.setState({ isFocused: false })
  }
}

// "withStreamlitConnection" is a wrapper function. It bootstraps the
// connection between your component and the Streamlit app, and handles
// passing arguments from Python -> Component.
//
// You don't need to edit withStreamlitConnection (but you're welcome to!).
export default withStreamlitConnection(MyComponent)
