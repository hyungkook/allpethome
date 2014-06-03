package kr.co.allpet.utils.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class XMLParserUtil {
	
	public static int SEARCH_MATCH_ALL = 1;
	public static int SEARCH_MATCH_PART = 2;
	
	public static int SEARCH_OR = 1;
	public static int SEARCH_AND = 2;
	
	public static class NodeMap1{
		
		Map<String,Object> value = new HashMap<String, Object>();
		Map<String,Object> attr = new HashMap<String, Object>();
		String name = "";
		
		
	}
	
	public Document getDOMObject(String type, String src){
		
		String server = src; // xml파일 주소
		URL url;
		URLConnection connection;
		InputStream is = null;
		InputStreamReader isr = null;
		BufferedReader br = null;
		StringBuffer strXML = new StringBuffer();
		try {
			url = new URL(server); // URL 세팅
			connection = url.openConnection(); // 접속
			is = connection.getInputStream(); // inputStream 이용
			
			isr = new InputStreamReader(is, "UTF-8");
			br = new BufferedReader(isr);
			String buf = null;

			while (true) { // 무한반복
				buf = br.readLine(); // 화면에 있는 내용을 \n단위로 읽어온다
				if (buf == null) { // null일 경우 화면이 끝난 경우이므로
					break; // 반복문 끝
				} else {
					strXML.append(buf);
					strXML.append("\n"); // strXML에 화면에 출력된 내용을 기억시킨다.
				}
			}
		} catch (MalformedURLException mue) {

			return null;
			
		} catch (IOException ioe) {
			
			ioe.printStackTrace();
			return null;
			
		} finally{
			
			if(br!=null){
				try {
					br.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			if(isr!=null){
				try {
					isr.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			if(is!=null){
				try {
					is.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		DocumentBuilder _docBuilder = null;
		try {
			_docBuilder = DocumentBuilderFactory.newInstance()
					.newDocumentBuilder();
		} catch (ParserConfigurationException e) {

			e.printStackTrace();
			return null;
		}
		
		Document document = null;
		try {
			document = _docBuilder.parse(new InputSource(
					new java.io.StringReader(strXML.toString())));
		} catch (SAXException e) {

			e.printStackTrace();
			return null;
			
		} catch (IOException e) {

			e.printStackTrace();
			return null;
		} 
		
		// strXML을 StringReader에 담고 InputSoruce클래스를 이용 DocumentBuilder.parse
		// 메소드를 이용하여 document문서로 만든다.
		
		document.setDocumentURI(server);
		
		return document;
	}

	/**
	 * XML 파일을 DOM 방식으로 파싱 (맵으로 반환)
	 * 메모리에 전부 올라가므로 초고용량 XML 파일일 경우 SAX방식 사용 필요
	 * 
	 * @author 박주엽
	 * @date 2013. 11. 27.
	 * 
	 * @param type 소스타입
	 * @param src type에 따라 값이 다름 type="URL"일 때 src=외부URL
	 * @return
	 */
	public HashMap<String, Object> parseByDOM(String type, String src) {
		Document document = getDOMObject(type, src);
		if(document==null)
			return null;
		
		Element e = document.getDocumentElement();

		HashMap<String, Object> root = new HashMap<String, Object>();
		root.put(e.getNodeName(), getNode(e, 0));
		
		return root;
	}
	
	/**
	 * searchKey 과 일치하는 것들만 파싱
	 * 
	 * searchKey는 트리구조로 0 - 루트, 1 - 루트의 자식, 2 - 그 아래 자식.. 의 형식
	 * 
	 * @return
	 */
	public ArrayList<Object> parseByDOM(String type, String src, ArrayList<String> searchKey) {
		Document document = getDOMObject(type, src);
		if(document==null)
			return null;
		
		keyTree = searchKey;
		
		keyTreeLen = keyTree.size();
		endPoint = keyTreeLen-2;
		
		Element e = document.getDocumentElement();
		
		return getSearchNode(new ArrayList<Object>(), e, 0);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> parseByDOM_valueOnly(String type, String URL) {
		
		Document document = getDOMObject(type, URL);
		
		if(document==null)
			return null;
		
		Element e = document.getDocumentElement();
		
		NodeList noneList = document.getDocumentElement().getChildNodes();

		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(); // 결과를 담을 배열 list
		list.add(getNode(e, 1));
		// 노드 길이 만큼
		
		list = (ArrayList<HashMap<String, Object>>) getRecursiveNodeList(list, noneList);

		return list;
	}
	
	public HashMap<String, Object> getNode(Node node, int l){
		
		HashMap<String, Object> root = new HashMap<String, Object>();
		HashMap<String, Object> attr = new HashMap<String, Object>();
		HashMap<String, Object> value = new HashMap<String, Object>();
		
		// 노드에 attribute 값이 있으면 attr 맵에 담는다.
		NamedNodeMap nnmap = node.getAttributes();
		if(nnmap != null){
			for(int i = 0; i < nnmap.getLength(); i++){
				attr.put(nnmap.item(i).getNodeName(), nnmap.item(i).getNodeValue());
			}
			root.put("attr", attr);
		}
		
		// 노드의 값을 담는다.
		NodeList noneList = node.getChildNodes();
		
		for(int i = 0; i < noneList.getLength(); i++){
			Node row = noneList.item(i);
			
			// row에 childBode를 NodeList에 담고
			if(row.getNodeType()==Node.ELEMENT_NODE){
				
				NodeList child = row.getChildNodes();
				String nodeName = row.getNodeName();
				
				if(child == null || child.getLength()==0){
					//System.out.println("???");
					//map.put(nodeName,row.getTextContent());
					if(value.get(nodeName)==null){
						ArrayList<String> arr = new ArrayList<String>();
						arr.add(row.getTextContent());
						value.put(nodeName,arr);
					}
					else{
						ArrayList<String> arr = new ArrayList<String>();
						arr.add(row.getTextContent());
						value.put(nodeName,arr);
					}
				}
				else if(child.getLength()==1){
					//System.out.println(i+":"+row.getNodeName()+","+child.item(0).getTextContent());
					if(value.get(nodeName)==null){
						ArrayList<String> arr = new ArrayList<String>();
						arr.add(child.item(0).getTextContent());
						value.put(nodeName,arr);
					}
					else{
						ArrayList<String> arr = (ArrayList<String>) value.get(nodeName);
						arr.add(child.item(0).getTextContent());
					}
				}
				else{
					//System.out.println(i+":"+row.getNodeName()+","+child.item(0).getTextContent());
					if(value.get(nodeName)==null){
						ArrayList<HashMap<String, Object>> arr = new ArrayList<HashMap<String, Object>>();
						arr.add(getNode(row, l+1));
						value.put(nodeName,arr);
					}
					else{
						ArrayList<HashMap<String, Object>> arr = (ArrayList<HashMap<String, Object>>) value.get(nodeName);
						arr.add(getNode(row, l+1));
					}
				}
			}
		}
		root.put("value", value);
		
		return root;
	}
	
	public ArrayList<Object> getSearchNode(ArrayList<Object> list, Node node, int l){
		
		boolean isEndPoint = false;
		if(endPoint == l && node.getNodeName().equals(getKey(l))){
			isEndPoint = true;
		}
		
		// 노드의 값을 담는다.
		NodeList noneList = node.getChildNodes();
		
		for(int i = 0; i < noneList.getLength(); i++){
			Node row = noneList.item(i);
			
			// row에 childBode를 NodeList에 담고
			if(row.getNodeType()==Node.ELEMENT_NODE){
				
				NodeList child = row.getChildNodes();
				
				if(child.getLength()==1){

					if(isEndPoint && row.getNodeName().equals(getKey(l+1))){
						list.add(child.item(0).getTextContent());
					}
					
				}
				else if(child != null && child.getLength()>1){
					if(isEndPoint && row.getNodeName().equals(getKey(l+1))){
						
						list.add(getNode(row, l+1));
					}
					else
						getSearchNode(list, row, l+1);	
				}
			}
		}
		
		return list;
	}
	
	public List getRecursiveNodeList(List list, NodeList noneList){
		
		for (int i = 0; i < noneList.getLength(); i++) { 
			
			// node row에 item들을 가져온다.
			Node row = noneList.item(i);
			
			// row에 childBode를 NodeList에 담고
			if(row.getNodeType()==Node.ELEMENT_NODE){
				NodeList child = row.getChildNodes();
				HashMap<String, Object> map = new HashMap<String, Object>();
				
				if(child == null || child.getLength()==0){
					//System.out.println("???");
					map.put(row.getNodeName(),row.getTextContent());
				}
				else if(child.getLength()==1){
					//System.out.println(i+":"+row.getNodeName()+","+child.item(0).getTextContent());
					map.put(row.getNodeName(),child.item(0).getTextContent());
				}
				else{
					//System.out.println("!!! "+row.getNodeName()+","+child.getLength()+","+child.item(0).getNodeName()+","+child.item(0).getTextContent());
					//System.out.println(i+":"+row.getNodeName()+","+child.item(0).getTextContent());
					map.put(row.getNodeName(),getRecursiveNodeList(new ArrayList<HashMap<String, Object>>(), child));
				}
				//for (int a = 0; a < child.getLength(); a++) {
				//	Node nodeList = child.item(a);
				//	map.put(nodeList.getNodeName(), nodeList.getTextContent());
				//}
				list.add(map);
			}
		}
		
		return list;
	}
	
	@SuppressWarnings("rawtypes")
	public static ArrayList<?> getValue(Map node, String key){
		
		Map m1 = (Map) node.get("value");
		
		if(m1.get(key)==null)
			return null;
		
		return (ArrayList<?>) m1.get(key);
	}
	
	@SuppressWarnings("rawtypes")
	public static String getAttribute(Map node, String key){
		
		Map m1 = (Map) node.get("attr");
		
		if(m1.get(key)==null)
			return null;
		
		return (String) m1.get(key);
	}
	
	/**
	 * SAX방식 미구현
	 */
	public HashMap<String, Object> parseBySAX(String type, String URL) {
		
		return null;
	}
	
	/**
	 * 검색
	 */
	
	ArrayList<String> keyTree = null;
	int keyTreeLen = 0;
	int endPoint = 0;
	
	private String getKey(int index){
		
		if(index < 0 || index > keyTreeLen-1)
			return null;
		else
			return keyTree.get(index);
	}
	
	int mSearchTotal = 0;
	int mPageNumber = 0;
	int mPageCount = 0;
	
	public int getSearchTotal(){
		
		return mSearchTotal;
	}
	
	public int getPageNumber(){
		
		return mPageNumber;
	}
	
	public int getPageCount(){
		
		return mPageCount;
	}
	
	List<Object> mSearchResultList = null;
	
	public List<Object> getSearchResultList(){
		
		return mSearchResultList;
	}
	
	/**
	 * 검색 결과는 getSearchResultList 로 받는다.
	 * 
	 * @param list 검색 대상
	 * @param search_tag 검색할 태그 이름
	 * @param search_val 일치해야 되는 태그의 값
	 * @param pageNumber 페이징
	 * @param size 페이징 한 그룹에서 리스트 개수
	 */
	@SuppressWarnings({ "rawtypes" })
	public void search(ArrayList<Object> list, String[] search_tag, String search_val, int pageNumber, int size){
		
		int len = list.size();
		ArrayList l = null;
		String s = null;
		
		// 검색할 것이 있을 경우 찾는다.
		if(Common.isValid(search_tag)){
			ArrayList<Object> newList = new ArrayList<Object>();
			
			for(int i = 0; i < len; i++){
				
				boolean isFound = false;
				for(String type:search_tag){
					if(type==null){continue;}
					l = getValue((Map) list.get(i), type);
					if(l != null && !l.isEmpty() && l.get(0) instanceof String){
						s = (String) l.get(0);
						if(s.indexOf(search_val)!=-1){
							isFound=true;
							break;
						}
					}
				}
				if(isFound){
					newList.add((Map) list.get(i));
				}
			}
			
			list = newList;
		}
		
		// 페이지 세팅
		if(pageNumber==0)
			pageNumber = 1;
		
		mSearchTotal = list.size();
		int start = size * (pageNumber-1);
		int end = start+size;
		if(end > mSearchTotal)
			end = mSearchTotal;
		
		mPageCount = (mSearchTotal-1) / size + 1;
		mPageNumber = pageNumber;
		
		mSearchResultList = list.subList(start, end);
	}
}
