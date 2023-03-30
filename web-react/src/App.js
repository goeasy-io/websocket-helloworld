// 导入路由
import {BrowserRouter, Route, Routes} from 'react-router-dom'

// 导入页面组件
import Index from './pages/index'

// 配置路由规则
function App() {
  return (
    <BrowserRouter>
      <div className="App">
        <Routes>
          <Route path="/" element={<Index/>}/>
          <Route path="/index" element={<Index/>}/>
        </Routes>
      </div>
    </BrowserRouter>
  )
}

export default App
